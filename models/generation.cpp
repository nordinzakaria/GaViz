#include "generation.h"

#include <algorithm>
#include <QDebug>
#include <QtMath>

Generation::Generation()
{

}

Generation::Generation(int nbClusters)
{
    this->setNumClusters(nbClusters);
}

int Generation::size() const
{
    int sum=0;
    for (int i=0; i<this->getNumClusters(); i++)
    {
        sum += this->getCluster(i)->getSize();
    }

    return sum;
}

void Generation::addIndividual(Individual* ind, int clus)
{
    Subcluster *cluster = this->getCluster(clus);
    cluster->addIndividual(ind);
}

Individual* Generation::getIndividual(int index) const
{
    int accindex=0;
    for (int i=0; i<this->getNumClusters(); i++)
    {
        Subcluster *cluster = this->getCluster(i);
        int sz = cluster->getSize();
        if (index < accindex+sz)
        {
            return cluster->getIndividual(index - accindex);
        }
        accindex += sz;
    }

    return nullptr;
}

QVector<Individual*> Generation::getIndividuals() const
{
    QVector<Individual*> result;
    for (int i=0; i<this->getNumClusters(); i++)
    {
        Subcluster *cluster = this->getCluster(i);
        result.append(cluster->getIndividuals());
    }

    return result;
}

int Generation::getIndCluster(int index) const
{
    int accindex=0;
    for (int i=0; i<this->getNumClusters(); i++)
    {
        Subcluster *cluster = this->getCluster(i);
        int sz = cluster->getSize();
        if (index < accindex+sz)
        {
            return i;
        }
        accindex += sz;
    }

    return -1;
}

float Generation::getMaxFitness(int findex) const
{
    float max = subclusters[0]->getMaxFitness(findex);
    //qDebug() << "Initial max " << max << "\n";
    for (int i=0; i<getNumClusters(); i++) {
        float val = subclusters[i]->getMaxFitness(findex);
        if (val > max)
            max = val;
    }

    return max;
}

float Generation::getMinFitness(int findex) const
{
    float min = subclusters[0]->getMinFitness(findex);
    for (int i=0; i<getNumClusters(); i++) {
        float val = subclusters[i]->getMinFitness(findex);
        if (val < min)
            min = val;
    }

    return min;
}

float Generation::getSumStd(int findex, float avg) const
{
    float sum = 0;
    for (int i=0; i<getNumClusters(); i++) {
        sum += subclusters[i]->getSumStd(findex, avg);
    }

    sum /= size();
    return qSqrt(sum);
}


void Generation::setNumClusters(int nbClusters)
{
    for (int i=0; i<nbClusters; i++) {
        Subcluster *sc = new Subcluster();
        subclusters.append(sc);
    }
}

Subcluster* Generation::getCluster(int index) const
{
    return subclusters[index];
}

int Generation::getNumClusters() const
{
    return subclusters.size();
}

void Generation::deleteCluster(int ci)
{
    delete subclusters[ci];
    subclusters.removeAt(ci);
}

void Generation::clearCluster()
{
    for (int i=0; i<getNumClusters(); i++)
    {
        delete subclusters[i];
    }

    subclusters.clear();
}

void Generation::addCluster()
{
    Subcluster *sc = new Subcluster();
    subclusters.append(sc);
}

void Generation::invert(float max, float min, int findex)
{
    for (int i=0; i<getNumClusters(); i++)
    {
        subclusters[i]->invert(max, min, findex);
    }
}


void Generation::invert(float max, int findex)
{
    for (int i=0; i<getNumClusters(); i++)
    {
        subclusters[i]->invert(max, findex);
    }
}
