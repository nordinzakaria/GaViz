#ifndef SUBCLUSTER_H
#define SUBCLUSTER_H

#include "individual.h"
#include <QVector>

class Subcluster
{
public:
    Subcluster();

    void setNumIndividual(int num);
    void addIndividual(Individual* ind);
    QVector<Individual*> getIndividuals()
    {
        return individuals;
    }

    int getSize() const;
    Individual* getIndividual(int index);
    float getMaxFitness(int findex) const;
    float getMinFitness(int findex) const;
    float getSumStd(int findex, float avg) const;
    void invert(float max, float min, int findex);
    void invert(float max, int findex);



private:
    QVector<Individual*> individuals;
};

#endif // SUBCLUSTER_H
