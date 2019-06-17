#include <QQmlEngine>
#include <QDebug>
#include <iostream>
#include <QImage>
#include <QtGlobal>

#include "population.h"


int Population::nbObjectiveFunctions;
QString *Population::objectives;
int Population::numPop;


Population::Population() :
    nbGenerations(0)
{ }

QVariantList Population::getIndividualProperty(int gen, int clus, int findex, int property) const
{
    if (gen < 0 || gen >= this->getNbGenerations())
        return QVariantList();

    Generation* generation = this->getGenerations(gen);

    if (clus < 0 || clus >= generation->getNumClusters())
        return QVariantList();

    Subcluster *cluster = generation->getCluster(clus);
    int sz = cluster->getSize();

    QList<QVariant> data;
    switch(property)
    {
        case Individual::Fitness:
        for (int i=0; i<sz; i++) {
            data.append(cluster->getIndividual(i)->getFitness(findex));
        }
        break;
    }

    return data;
}

QVariant Population::getGene(int gen, int clus, int index, int geneindex) const
{
    if (gen < 0 || gen >= this->getNbGenerations())
        return QVariant();

    Generation* generation = this->getGenerations(gen);

    if (clus < 0 || clus >= generation->getNumClusters())
        return QVariant();

    Subcluster *cluster = generation->getCluster(clus);
    if (index < 0 || index >= cluster->getSize())
        return QVariant();

    Individual *indiv = cluster->getIndividual(index);
    if (geneindex < 0 || geneindex >= indiv->getNumGenes())
        return QVariant();

    return indiv->getGene(geneindex);
}

QVariant Population::getIndividualProperty(int gen, int clus, int index, int findex, int property) const
{
    if (gen < 0 || gen >= this->getNbGenerations()) {
        qDebug() << "Invalid request for gen " << gen << ", index = "<< index << ", findex " << findex << ", prop " << property << "\n";
        return QVariant();
    }

    Generation* generation = this->getGenerations(gen);

    if (clus < 0 || clus >= generation->getNumClusters()) {
        qDebug() << "Invalid request for gen " << gen << ", index = "<< index << ", findex " << findex << ", prop " << property << "\n";
        return QVariant();
    }

    Subcluster *cluster = generation->getCluster(clus);
    if (index < 0 || index >= cluster->getSize()) {
        qDebug() << "Invalid request for gen " << gen << ", index = "<< index << ", findex " << findex << ", prop " << property << "\n";
        return QVariant();
    }

    switch(property)
    {
        case Individual::Fitness:
                return cluster->getIndividual(index)->getFitness(findex);
        case Individual::Rank:
                //qDebug() << "rank of ind " << index << " is " << cluster->getIndividual(index)->getRank() << "\n";
                return cluster->getIndividual(index)->getRank();
        case Individual::Parent1:
                return cluster->getIndividual(index)->getParent1();
        case Individual::Parent2:
                return cluster->getIndividual(index)->getParent2();
        case Individual::NumGenes:
            qDebug() << "returning numgenes = "<< cluster->getIndividual(index)->getNumGenes() << "\n";
            return cluster->getIndividual(index)->getNumGenes();
        default:
                qDebug() << "Invalid request for gen " << gen << ", index = "<< index << ", findex " << findex << ", prop " << property << "\n";
                return QVariant();
    }
}

void Population::addIndividual(Individual *ind){
    int gen = ind->getGeneration();
    int cluster = ind->getCluster();

    //std::cout << "Adding ind to gen " << gen << " cluster " << cluster << std::endl;
    //std::cout << " Num generation is " << this->getNbGenerations() << std::endl;
    Generation * generation = this->getGenerations(gen);
    //std::cout << " Num cluster in this generation is " << generation->getNumClusters() << std::endl;
    generation->addIndividual(ind, cluster);
}

float Population::getMaxFitness(int gen, int findex) const
{
    return this->getGenerations(gen)->getMaxFitness(findex);
}

float Population::getMinFitness(int gen, int findex) const
{
    return this->getGenerations(gen)->getMinFitness(findex);
}

float Population::getMaxFitness(int findex) const
{
    float max = this->getGenerations(0)->getMaxFitness(findex);
    for (int i=0; i<this->getNbGenerations(); i++) {
        float val = this->getGenerations(i)->getMaxFitness(findex);
        if (val > max)
            max = val;
    }

    return max;
}

float Population::getMinFitness(int findex) const
{
    float min = this->getGenerations(0)->getMinFitness(findex);
    for (int i=0; i<this->getNbGenerations(); i++) {
        float val = this->getGenerations(i)->getMinFitness(findex);
        if (val < min)
            min = val;
    }

    return min;
}


int Population::getMaxNbIndPerGeneration() const
{
    int max = this->getGenerations(0)->size();
    for (int i=1; i<this->getNbGenerations(); i++)
    {
        int sz = this->getGenerations(i)->size();
        if (sz > max)
        {
            max = sz;
        }
    }

    return max;
}

int Population::getNbGenerations() const
{
    return nbGenerations;
}

int Population::getNbObjectiveFunctions()
{
    return Population::nbObjectiveFunctions;
}

void Population::setNbObjectiveFunctions(int num)
{
    Population::nbObjectiveFunctions = num;
    Population::objectives = new QString[num];
}

void Population::setObjectiveFunction(QString str, int index)
{
    Population::objectives[index] = str;
}

QString* Population::getObjectiveFunctions()
{
    return Population::objectives;
}

QString Population::getObjectiveFunction(int index)
{
    return Population::objectives[index];
}

Generation* Population::getGenerations(int index) const
{
    return &generations[index];
}

void Population::setNumGenerations(int num)
{
    this->nbGenerations = num;
    generations = new Generation[num];
}


void Population::invert(float max, float min, int findex)
{
    for (int i=0; i<this->getNbGenerations(); i++)
    {
        generations[i].invert(max, min, findex);
    }
}

void Population::invert(float max, int findex)
{
    for (int i=0; i<this->getNbGenerations(); i++)
    {
        generations[i].invert(max, findex);
    }
}

int Population::getNbPop()
{
    return Population::numPop;
}

void Population::setNbPop(int np)
{
    Population::numPop = np;
}

QImage Population::getImageIndividuals(float minScore)
{
    Generation currentGeneration;
    QVector<Individual* > currentIndividuals;
    Individual *currentIndividual;

    int generationSize = generations->size();

    /**
      *  TODO  : getMaxIndividualsByGeneration,
      *  even tho each generation should have the same amount of individuals
      *
      */
    int individualsByGeneration = generations[0].size();

    QImage *image = new QImage(generationSize, 100, QImage::Format_RGBA64);  // The image that we will create
    QRgba64 color ;

    for (int i = 0; i < generationSize ; i++) {
        currentGeneration = generations[i];
        currentIndividuals = currentGeneration.getIndividuals();
        for (int j = 0; j < individualsByGeneration;j++) {
            currentIndividual = currentIndividuals.at(j);
            float fitness = *currentIndividual->getFitness();

            if (fitness > minScore){
                //color = QRgba64::fromRgba(rand()%255,rand()%255,rand()%255,255);
                float minimum = minScore;
                float maximum = minScore+5;

                float ratio = 2 * (fitness-minimum) / (maximum - minimum);

                int b = qMax(0.f, 255*(1 - ratio));
                int r = qMax(0.f, 255*(ratio - 1));
                int g = 255 - b - r;

                std::cout << "generation: " << i << " individue: " << j<< std::endl;
                std::cout << "|r = " << r;
                std::cout << "|b = " << b;
                std::cout << "|g = " << g << std::endl;

                r = qMin(r,255);
                b = qMin(b,255);
                g = qMin(g,255);
                r = qMax(r,0);
                b = qMax(b,0);
                g = qMax(g,0);

                //TODO convert to short

                color = QRgba64::fromRgba(r, g, b, 255);

            }else{
                color = QRgba64::fromRgba(0,0,0,0);
            }

            // TODO : set the pixel color with a real value
            image->setPixelColor(i,j,color);
        }
    }

    return *image;
}
