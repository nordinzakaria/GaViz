#ifndef GENERATION_H
#define GENERATION_H

#include "subcluster.h"

class Generation
{

public:
    Generation();
    Generation(int nbClusters);

    void setNumClusters(int i);
    Subcluster* getCluster(int index) const;
    int getNumClusters() const;
    void deleteCluster(int ci);
    void clearCluster();
    void addCluster();
    int getIndCluster(int index) const;

    int size() const;
    Individual* getIndividual(int index) const;
    QVector<Individual*> getIndividuals() const;
    void addIndividual(Individual* ind, int cluster);

    float getMaxFitness(int findex) const;
    float getMinFitness(int findex) const;
    float getSumStd(int findex, float avg) const;

    void invert(float max, float min, int findex);
    void invert(float max, int findex);

private:
    QList<Subcluster*> subclusters;
};

#endif // GENERATION_H
