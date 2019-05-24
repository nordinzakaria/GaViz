#include "subcluster.h"

Subcluster::Subcluster()
{

}

void Subcluster::addIndividual(Individual *individual)
{
    individuals.append(individual);
}

int Subcluster::getSize() const
{
    return individuals.size();
}

Individual* Subcluster::getIndividual(int index)
{
    return individuals[index];
}

float Subcluster::getMaxFitness(int findex) const
{
    float max = this->individuals.at(0)->getFitness(findex);
    for (int i=0; i<this->getSize(); i++) {
        float val = this->individuals.at(i)->getFitness(findex);
        if (val > max)
            max = val;
    }

    return max;
}

float Subcluster::getMinFitness(int findex) const
{
    float min = this->individuals.at(0)->getFitness(findex);
    for (int i=0; i<this->getSize(); i++) {
        float val = this->individuals.at(i)->getFitness(findex);
        if (val < min)
            min = val;
    }

    return min;
}

float Subcluster::getSumStd(int findex, float avg) const
{
    float sum = 0;
    for (int i=0; i<this->getSize(); i++) {
        float val = this->individuals.at(i)->getFitness(findex);
        sum += (val - avg)*(val - avg);
    }

    return sum;
}

void Subcluster::invert(float max, float min, int findex)
{
    for (int i=0; i<this->getSize(); i++)
    {
        this->individuals.at(i)->invert(max, min, findex);
    }
}


void Subcluster::invert(float max, int findex)
{
    for (int i=0; i<this->getSize(); i++)
    {
        this->individuals.at(i)->invert(max, findex);
    }
}
