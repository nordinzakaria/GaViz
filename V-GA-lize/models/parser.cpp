#include <QFile>
#include <QUrl>
#include <QDebug>
#include <vector>
#include <iostream>
#include <limits>


#include "parser.h"

Parser::Parser()
{

}

Population* Parser::parseFile(QUrl fileUrl)
{
    this->fileUrl = fileUrl;    
    run();
    return this->population;
}

/* <chromosome-type>  <numfitness> <...fitness names...>  <...invert_fitness ...> <numpop> <numgen> <numcluster> <numind> <fitness0>..<fitnessN> <rank> <p0> <p1> <numchr> chromosome-vals   */

void Parser::run()
{
    QString qs = fileUrl.toLocalFile();
    QFile *data = new QFile(qs);

    std::cout << "Attempting to read from " << qs.toStdString() << std::endl;

    if (!data->open(QFile::ReadOnly))
        return;

    QTextStream input(data);
    ChromosomeDataType cdt;
    int token = 0;
    input >> token;
    cdt = static_cast<ChromosomeDataType> (token);
    Individual::setChrType(cdt);

    if (cdt == ChromosomeDataType::FLOAT)
    {
        Individual::setGeneMin(std::numeric_limits<float>::infinity());
        Individual::setGeneMax(-std::numeric_limits<float>::infinity());
    }
    else
    if (cdt == ChromosomeDataType::DOUBLE)
    {
        Individual::setGeneMin(std::numeric_limits<double>::infinity());
        Individual::setGeneMax(-std::numeric_limits<double>::infinity());
    }
    else
    if (cdt == ChromosomeDataType::INTEGER)
    {
        Individual::setGeneMin(std::numeric_limits<int>::infinity());
        Individual::setGeneMax(-std::numeric_limits<int>::infinity());
    }


    int numfitness = 0;
    input >> numfitness;
    Population::setNbObjectiveFunctions(numfitness);

    //std::cout << "numfitness = " << numfitness << std::endl;
    //std::cout.flush();

    for (int fstr=0; fstr < numfitness; fstr++)
    {
        QString str;
        input >> str;
        Population::setObjectiveFunction(str, fstr);
    }

    int *invert = new int[numfitness];
    // global max/min
    float *maxfitness = new float[numfitness];
    float *minfitness = new float[numfitness];

    // generation-specific max/min
    float *sumGFitness = new float[numfitness];
    float *minGFitness = new float[numfitness];
    float *maxGFitness = new float[numfitness];


    for (int ifit=0; ifit<numfitness; ifit++)
    {
        input >> invert[ifit];
        maxfitness[ifit] = -std::numeric_limits<float>::max();
        minfitness[ifit] = std::numeric_limits<float>::max();
    }

    int numpop;
    input >> numpop;
    population = new Population[numpop];
    Population::setNbPop(numpop);

    for (int np=0; np<numpop; np++)
    {
            int numgen = 0;
            input >> numgen;
            //std::cout << "numgen = " << numgen << std::endl;

            population[np].setNumGenerations(numgen);
            population[np].setStats(numfitness, numgen);

            for(int ng=0; ng < numgen; ng++) {

                Generation* gen = population[np].getGenerations(ng);

                for (int ifit=0; ifit<numfitness; ifit++)
                {
                    maxGFitness[ifit] = -std::numeric_limits<float>::max();
                    minGFitness[ifit] = std::numeric_limits<float>::max();
                    sumGFitness[ifit] = 0;
                }

                int numcluster = 0;
                input >> numcluster;
                //std::cout << "at gen " << ng << std::endl;
                //std::cout << "numcluster = " << numcluster << std::endl;
                gen->setNumClusters(numcluster);

                for (int nc=0; nc<numcluster; nc++) {

                    int numind = 0;
                    input >> numind;
                    //std::cout << "numind = " << numind << std::endl;

                    for (int ni=0; ni<numind; ni++) {
                         float *fitness = new float[numfitness];
                         for (int fi=0; fi<numfitness; fi++) {
                                 input >> fitness[fi];
                                 if (fitness[fi] > maxGFitness[fi]) {
                                     maxGFitness[fi] = fitness[fi];
                                 }
                                 if (fitness[fi] < minGFitness[fi]) {
                                     minGFitness[fi] = fitness[fi];
                                 }

                                 sumGFitness[fi] += fitness[fi];

                                 if (fitness[fi] > maxfitness[fi]) {
                                     maxfitness[fi] = fitness[fi];
                                 }
                                 if (fitness[fi] < minfitness[fi]) {
                                     minfitness[fi] = fitness[fi];
                                 }
                         }

                         int rank= 0;
                         input >> rank;

                         int p0 = -1;
                         int p1 = -1;
                         input >> p0 >> p1;

                         int  chrsize;
                         input >> chrsize;

                         Individual *ind = new Individual();
                         ind->setRank(rank);
                         ind->setGeneration(ng);
                         ind->setCluster(nc);
                         ind->setFitness(fitness);
                         ind->setParents(p0, p1);
                         ind->setNumGenes(chrsize);

                         ChromosomeType ct;
                         switch (cdt) {
                            case FLOAT:
                             ct.arrayf = new float[chrsize];
                             for (int ch=0; ch<chrsize; ch++)
                             {
                                 input >> ct.arrayf[ch];
                                 if (ct.arrayf[ch] > Individual::getGeneMax().toFloat())
                                     Individual::setGeneMax(ct.arrayf[ch]);
                                 if (ct.arrayf[ch] < Individual::getGeneMin().toFloat())
                                     Individual::setGeneMin(ct.arrayf[ch]);
                             }
                             break;
                            case INTEGER:
                             ct.arrayI = new int[chrsize];
                             for (int ch=0; ch<chrsize; ch++)
                             {
                                 input >> ct.arrayI[ch];
                                 if (ct.arrayI[ch] > Individual::getGeneMax().toInt())
                                     Individual::setGeneMax(ct.arrayI[ch]);
                                 if (ct.arrayI[ch] < Individual::getGeneMin().toInt())
                                     Individual::setGeneMin(ct.arrayI[ch]);
                             }
                             break;
                            case DOUBLE:
                             ct.arrayD = new double[chrsize];
                             for (int ch=0; ch<chrsize; ch++)
                             {
                                 input >> ct.arrayD[ch];
                                 if (ct.arrayD[ch] > Individual::getGeneMax().toDouble())
                                     Individual::setGeneMax(ct.arrayD[ch]);
                                 if (ct.arrayD[ch] < Individual::getGeneMin().toDouble())
                                     Individual::setGeneMin(ct.arrayD[ch]);
                             }
                             break;
                            case CHAR:
                             ct.arrayC = new char[chrsize];
                             for (int ch=0; ch<chrsize; ch++)
                             {
                                 input >> ct.arrayC[ch];
                             }
                             break;
                            case STRING:
                             ct.arrayS = new QString[chrsize];
                             for (int ch=0; ch<chrsize; ch++)
                             {
                                 input >> ct.arrayS[ch];
                             }
                             break;
                         }

                         ind->setChromosomes(ct, fitness);
                         population[np].addIndividual(ind);
                    }

                }

                for (int ifit=0; ifit<numfitness; ifit++)
                {
                    Stats *ngstat = new Stats();
                    ngstat->setMin(minGFitness[ifit]);
                    ngstat->setMax(maxGFitness[ifit]);
                    ngstat->setAverage(sumGFitness[ifit] / gen->size());
                    ngstat->setStddev(gen->getSumStd(ifit, ngstat->average()));
                    population[np].setStats(ifit, ng, ngstat);
                }

                emit madeProgress(ng / (float) numgen);
            }
    }

    for (int np=0; np<numpop; np++)
    {
        for (int fi=0; fi<numfitness; fi++)
        {
            if (!invert[fi])
                continue;

            for (int g=0; g<population[np].getNbGenerations(); g++)
            {
                Stats *s = population[np].getStats(fi, g);
                Population::invert(maxfitness[fi], minfitness[fi], s);
            }


            population[np].invert(maxfitness[fi], minfitness[fi], fi);
        }
    }

    delete[] maxfitness;
    delete[] minfitness;
    delete[] maxGFitness;
    delete[] minGFitness;
    delete[] sumGFitness;

}


