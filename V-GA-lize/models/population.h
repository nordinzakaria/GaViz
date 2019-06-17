#ifndef POPULATION_H
#define POPULATION_H

#include "generation.h"
#include "stats.h"
#include <QVariant>

class Population : public QObject
{
    Q_OBJECT

public:
    Population();

    void addIndividual(Individual *ind);

    QVariant getIndividualProperty(int generation, int cluster, int index, int findex, int property) const;

    QVariant getGene(int generation, int cluster, int index, int geneindex) const;

    QImage getImageIndividuals();

    QVariantList getIndividualProperty(int generation, int cluster, int findex, int property) const;

    float getMaxFitness(int gen, int findex) const;
    float getMinFitness(int gen, int findex) const;

    float getMaxFitness(int findex) const;
    float getMinFitness(int findex) const;

    int getNbGenerations() const;
    int getMaxNbIndPerGeneration() const;
    Generation* getGenerations(int index) const;
    void setNumGenerations(int num);

    void setStats(int numf, int numg)
    {
        stats = new Stats*[numf*numg];
    }

    void setStats(int findex, int gindex, Stats *st)
    {
        stats[findex*getNbGenerations() + gindex] = st;
    }


    Stats** getStats(int findex) const {
        int index = findex*getNbGenerations();
        return &stats[index];
    }
    Stats* getStats(int findex, int gindex) const {
        return this->stats[findex*getNbGenerations() + gindex];
    }

    static int getNbObjectiveFunctions();
    static QString* getObjectiveFunctions();
    static QString getObjectiveFunction(int index);
    static void setNbObjectiveFunctions(int num);
    static void setObjectiveFunction(QString str, int index);
    static int getNbPop();
    static void setNbPop(int np);

    static float invert(float max, float min, float val)
    {
        return (max - val) / (max - min);
    }

    static void invert(float max, float min, Stats *astats)
    {
        astats->setAverage(Population::invert(max, min, astats->average()));
        astats->setMin(Population::invert(max, min, astats->min()));
        astats->setMax(Population::invert(max, min, astats->max()));
        astats->setStddev(Population::invert(max, min, astats->stddev()));
    }


    void invert(float max, float min, int findex);
    void invert(float max, int findex);

private:

    int nbGenerations;
    static int numPop;
    static int nbObjectiveFunctions;
    static QString *objectives;
    Generation* generations;
    Stats** stats;
};

#endif // POPULATION_H
