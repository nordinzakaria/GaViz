#ifndef GAVIZ_H
#define GAVIZ_H

#include <QObject>
#include <QUrl>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QPalette>
#include <QDebug>

#include "parser.h"

/*!
    \class GAViz
    \brief The main QObject-derived class that interface the qml interface (view) to the metaheuristic data (the model).

    The metaheuristics data comprises of <numpop> populations.
    A population has <numgen> generations.
    A generation consists of <numcluster> clusters, and a cluster contains <numind> individuals.
    The values above (in <>) can vary for each population or generation or cluster.

    An individual contains <numfitness> values, and comprises of <numgenes> genes.
    <numfitness> is fixed globally, that is for all individuals across all populations, generations and clusters.
    <numgenes> can vary for each individual.

    The fitness values in a dataset can be inverted: value = max_value - value.
    To do so the <invert_fitness> is set to 1 for a fitness value;  0 indicates no inversion.

    The data type <chromosome-type> of each gene in the data can be one of the following integers:
            0 :  FLOAT
            1 :  INTEGER
            2 :  DOUBLE
            3 :  CHAR
            4 :  STRING


    The metaheuristic data file is assumed to be in the following format
    (ignore new lines and indentation - those are just to make the following readable):

    <chromosome-type>
    <numfitness> numfitness*<fitness names>  numfitness*<invert_fitness>
    <numpop>
     numpop*{
              <numgen>
               numgen*{
                        <numcluster>
                         numcluster*{
                                      <numind>
                                       numind*{
                                                numfitness*<fitness-value> <rank> <p0> <p1> <numgenes> numgenes*<values>
                                              }
                                    }
                      }
            }
 */

namespace GAVizErrors
{
    Q_NAMESPACE         // required for meta object creation
    enum GAVizError {
        NO_ERROR,
        PARSE_ERROR,
        POPULATION_NULL,
        INDEX_OUT_OF_RANGE
    };
    Q_ENUM_NS(GAVizError)  // register the enum in meta object data
}

namespace GAVizStats
{
    Q_NAMESPACE         // required for meta object creation
    enum GAVizStats {
        AVERAGE,
        MIN,
        MAX,
        STDDEV
    };
    Q_ENUM_NS(GAVizStats)  // register the enum in meta object data
}


class GAViz : public QThread  //QObject
{
    Q_OBJECT

    Q_PROPERTY(QPalette palette READ palette CONSTANT)
    Q_PROPERTY(float progress READ progress WRITE setProgress NOTIFY progressChanged)

public:
    //explicit GAViz(QQmlApplicationEngine *engine);
    GAViz();

    float progress() const
        { return m_progress; }

    /*!
        \fn void readGAFile(QUrl fileUrl);
        \brief Reads metaheuristic data from fileUrl
     */
    Q_INVOKABLE void readGAFile(QUrl fileUrl);

    /*!
        \fn int getNbPopulations()
        \brief get number of populations
     */
    Q_INVOKABLE int getNbPopulations()
    {
        return this->numPops();
    }

    /*!
        \fn int getNbObjectiveFunctions()
        \brief get number of objective functions
     */
    Q_INVOKABLE int getNbObjectiveFunctions()
    {
        return Population::getNbObjectiveFunctions();
    }

    /*!
        \fn QVariantList getObjectiveFunctions()
        \brief get the names of the objective functions
     */
    Q_INVOKABLE QVariantList getObjectiveFunctions()
    {
        if (names.size() == 0)
        {
            for (int i=0; i<this->getNbObjectiveFunctions(); i++)
                names.append(Population::getObjectiveFunction(i));
        }

        return names;
    }

    /*!
        \fn QVariant getObjectiveFunction(int i)
        \brief get the name of the i-th objective function
     */
    Q_INVOKABLE QVariant getObjectiveFunction(int index)
    {
        return Population::getObjectiveFunction(index);
    }

    /*!
        \fn QVariant getNbGenerations()
        \brief get the number of generations from the first population
     */
    Q_INVOKABLE QVariant getNbGenerations()
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        return population->getNbGenerations();
    }

    /*!
        \fn QVariant getNbGenerations(int i)
        \brief get the number of generations from the i-th population
     */
    Q_INVOKABLE QVariant getNbGenerations(int index)
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        if (index < 0 || index >=  this->getNbPopulations())
        {
            return GAVizErrors::INDEX_OUT_OF_RANGE;
        }


        return population[index].getNbGenerations();
    }

    /*!
        \fn QVariant getMaxNbIndPerGeneration(int i)
        \brief get the maximum number of individuals in any generation in the i-th population
     */
    Q_INVOKABLE QVariant getMaxNbIndPerGeneration(int index)
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        if (index < 0 || index >=  this->getNbPopulations())
        {
            return GAVizErrors::INDEX_OUT_OF_RANGE;
        }

        return population[index].getMaxNbIndPerGeneration();
    }

    /*!
        \fn QVariant getMaxNbIndPerGeneration()
        \brief get the maximum number of individuals in any generation in the first population
     */
    Q_INVOKABLE QVariant getMaxNbIndPerGeneration()
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        return population->getMaxNbIndPerGeneration();
    }


    /*!
        \fn QVariant getNbIndInGeneration(int i)
        \brief get the number of individuals in the i-th generation in the first population
     */
    Q_INVOKABLE QVariant getNbIndInGeneration(int gindex)
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        return population->getGenerations(gindex)->size();
    }

    /*!
        \fn QVariant getNbIndInGeneration(int p, int i)
        \brief get the number of individuals in the i-th generation in the p-th population
     */
    Q_INVOKABLE QVariant getNbIndInGeneration(int pindex, int gindex)
    {
        if (population == nullptr)
        {
            return GAVizErrors::POPULATION_NULL;
        }

        if (pindex < 0 || pindex >=  this->getNbPopulations())
        {
            return GAVizErrors::INDEX_OUT_OF_RANGE;
        }

        return population[pindex].getGenerations(gindex)->size();
    }


    /*!
        \fn QVariant getGeneMax()
        \brief get max gene value
     */
    Q_INVOKABLE QVariant getGeneMax()
    {
        return Individual::getGeneMax();
    }

    /*!
        \fn QVariant getGeneMin()
        \brief get min gene value
     */
    Q_INVOKABLE QVariant getGeneMin()
    {
        return Individual::getGeneMin();
    }


    /*!
        \fn QVariant getGene(int g, int c, int i, int h)
        \brief get the h-th gene from the i-th individual in the g-th generation, c-th cluster in the first population.
     */

    Q_INVOKABLE QVariant getGene(int gen, int clus, int index, int geneindex)
    {
        return population->getGene(gen, clus, index, geneindex);
    }

    /*!
        \fn QVariant getGene(int p, int g, int c, int i, int h)
        \brief get the h-th gene from the i-th individual in the g-th generation, c-th cluster in the p-th population.
     */

    Q_INVOKABLE QVariant getGene(int pop, int gen, int clus, int index, int geneindex)
    {
        return population[pop].getGene(gen, clus, index, geneindex);
    }

    /*!
        \fn QVariant getIndividualProperty(int g, int c, int i, int f, int property)
        \brief get the property of the i-th individual in the g-th generation, c-th cluster in the first population. If it's fitness property, take the f-th fitness val.
     */

    Q_INVOKABLE QVariant getIndividualProperty(int gen, int clus, int index, int findex, int property)
    {
        return population->getIndividualProperty(gen, clus, index, findex, property);
    }

    /*!
        \fn QVariant getIndividualProperty(int p, int g, int c, int i, int f, int property)
        \brief get the property of the i-th individual in the g-th generation, c-th cluster in the pth population. If it's fitness property, take the f-th fitness val.
     */

    Q_INVOKABLE QVariant getIndividualProperty(int pop, int gen, int clus, int index, int findex, int property)
    {
        return population[pop].getIndividualProperty(gen, clus, index, findex, property);
    }


    /*!
        \fn QVariantList getIndividualPropertyList(int g, int c, int f, int property)
        \brief get the property of the individuals in the g-th generation, c-th cluster in the first population. If it's fitness property, take the f-th fitness val.
     */

    Q_INVOKABLE QVariantList getIndividualPropertyList(int gen, int clus, int findex, int property)
    {
        return population->getIndividualProperty(gen, clus, findex, property);
    }

    /*!
        \fn QVariantList getIndividualPropertyList(int g, int c, int f, int property)
        \brief get the property of the individuals in the g-th generation, c-th cluster in the first population. If it's fitness property, take the f-th fitness val.
     */

    Q_INVOKABLE QVariantList getIndividualPropertyList(int pop, int gen, int clus, int findex, int property)
    {
        return population[pop].getIndividualProperty(gen, clus, findex, property);
    }




    /*!
        \fn QVariant getMaxFitness(int f) const;
        \brief get the maximum f-th fitness in all populations.
     */
    Q_INVOKABLE QVariant getMaxFitness(int findex) const;

    /*!
        \fn QVariant getMinFitness(int f) const;
        \brief get the minimum f-th fitness in all populations.
     */
    Q_INVOKABLE QVariant getMinFitness(int findex) const;

    /*!
        \fn QVariant getMaxFitness(int p, int f) const;
        \brief get the maximum f-th fitness in the p-th population.
     */
    Q_INVOKABLE QVariant getMaxFitness(int pindex, int findex) const;

    /*!
        \fn QVariant getMaxFitness(int p, int g, int f) const;
        \brief get the maximum f-th fitness in the g-th generation of the p-th population.
     */
    Q_INVOKABLE QVariant getMaxFitness(int pindex, int gindex, int findex) const;


    /*!
        \fn QVariant getMinFitness(int p, int f) const;
        \brief get the minimum f-th fitness in the p-th population.
     */
    Q_INVOKABLE QVariant getMinFitness(int pindex, int findex) const;

    /*!
        \fn QVariant getMinFitness(int p, int g, int f) const;
        \brief get the minimum f-th fitness in the g-th generation of the p-th population.
     */
    Q_INVOKABLE QVariant getMinFitness(int pindex, int gindex, int findex) const;


    /*!
        \fn int numPops()
        \brief get the number of populations
     */
    Q_INVOKABLE int numPops()
    {
        return Population::getNbPop();
    }

    Q_INVOKABLE QImage getImageIndividuals(float minScore)
    {
        return population->getImageIndividuals(minScore);
    }

    /*!
        \fn int numPops()
        \brief get the number of populations
     */
    Q_INVOKABLE float getStats(int gindex, int findex, int which) const
       {
           Stats** pstats = population->getStats(findex);

           switch (which) {
           case Stats::AVERAGE:
               return pstats[gindex]->average();
           case Stats::MIN:
               return pstats[gindex]->min();
           case Stats::MAX:
               return pstats[gindex]->max();
           case Stats::STDDEV:
               return pstats[gindex]->stddev();
           }

           return 0;
       }

    /*!
        \fn float getStats(int p, int g, int f, int w)
        \brief get f-th stats  of type w from the gindex gen, p-th pop
     */
    Q_INVOKABLE float getStats(int pindex, int gindex, int findex, int which) const
       {
           Stats** pstats = population[pindex].getStats(findex);

           switch (which) {
           case Stats::AVERAGE:
               return pstats[gindex]->average();
           case Stats::MIN:
               return pstats[gindex]->min();
           case Stats::MAX:
               return pstats[gindex]->max();
           case Stats::STDDEV:
               return pstats[gindex]->stddev();
           }

           return 0;
       }

    Q_INVOKABLE float getMinStats(int pindex, int findex, int which) const
       {
           Stats** pstats = population[pindex].getStats(findex);

           switch (which) {

            case Stats::AVERAGE:
            {
                float minAverage = 999999999999999999;
                for(int i = 0; i < population[pindex].getNbGenerations(); i++)
                {
                    if(pstats[i]->average() < minAverage)
                        minAverage = pstats[i]->average();
                }
                return minAverage;
            }
            case Stats::MIN:
            {
               float minMinimum = 999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() < minMinimum)
                       minMinimum = pstats[i]->min();
               }
               return minMinimum;
            }
            case Stats::MAX:
            {
               float minMaximum = 999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() < minMaximum)
                       minMaximum = pstats[i]->max();
               }
               return minMaximum;
            }
            case Stats::STDDEV:
            {
               float minStddev = 999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() < minStddev)
                       minStddev = pstats[i]->average();
               }
               return minStddev;
            }
           }

           return 0;
       }
    Q_INVOKABLE float getMaxStats(int pindex, int findex, int which) const
       {
           Stats** pstats = population[pindex].getStats(findex);

           switch (which) {

            case Stats::AVERAGE:
            {
                float maxAverage = -999999999999999999;
                for(int i = 0; i < population[pindex].getNbGenerations(); i++)
                {
                    if(pstats[i]->average() > maxAverage)
                        maxAverage = pstats[i]->average();
                }
                return maxAverage;
            }
            case Stats::MIN:
            {
               float maxMinimum = -999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() > maxMinimum)
                       maxMinimum = pstats[i]->min();
               }
               return maxMinimum;
            }
            case Stats::MAX:
            {
               float maxMaximum = -999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() > maxMaximum)
                       maxMaximum = pstats[i]->max();
               }
               return maxMaximum;
            }
            case Stats::STDDEV:
            {
               float maxStddev = -999999999999999999;
               for(int i = 0; i < population[pindex].getNbGenerations(); i++)
               {
                   if(pstats[i]->average() > maxStddev)
                       maxStddev = pstats[i]->average();
               }
               return maxStddev;
            }
           }

           return 0;
       }

    Q_INVOKABLE QString getLocalFile(QUrl file)
    {
        return file.toLocalFile();
    }


    QPalette palette() const { return *customPalette; }

public:
    Parser* parser;
    static Population* population;
    QPalette* customPalette;

protected:
    void run();

public slots:
    void setProgress(float prog)
        {
            m_progress = prog;
            emit progressChanged(m_progress);
        }

signals:
    void doneLoadingFile(QVariant success, QVariant nbGenerations, QVariant nbObjectiveFunctions);
    void progressChanged(float prog);

private:
    //QQmlApplicationEngine *engine;
    QList<QVariant> names;
    QUrl fileUrl;
    float m_progress;


};

#endif // GAVIZ_H
