#include "individual.h"

#include <QDebug>

ChromosomeDataType Individual::chrtype;

QVariant Individual::maxgene;
QVariant Individual::mingene;


Individual::Individual() :
    generation(-1), cluster(-1), parent1(-1), parent2(-1), fitness(nullptr), rank(-1)
{

}

Individual::Individual(int generation, int cluster, int parent1, int parent2, float *fitness, ChromosomeType chromosome, int rank)
{
    this->setGeneration(generation);
    this->setCluster(cluster);
    if (parent1 < -1)
        parent1 = -1;
    if (parent2 < -1)
        parent2 = -1;
    this->setParents(parent1, parent2);
    this->setChromosomes(chromosome, fitness);
    this->setRank(rank);
    this->setFitness(fitness);
}

void Individual::setNumFitness(int f)
{
    this->fitness = new float[f];
    this->numFitness = f;
}

void Individual::setNumGenes(int ng)
{
    this->numgenes = ng;
}

int Individual::getNumFitness() const
{
    return this->numFitness;
}

int Individual::getNumGenes() const
{
    return this->numgenes;
}



void Individual::setRank(int rank) {
    this->rank = rank;
}

void Individual::setFitness(float *fitness) {
    this->fitness = fitness;
}

void Individual::setFitness(float fitness, int index) {
    this->fitness[index] = fitness;
}


int Individual::getRank() const {
    return this->rank;
}

void Individual::setGeneration(int g) {
    this->generation = g;

}

void Individual::setCluster(int c) {
        this->cluster = c;
}

void Individual::setParents(int p0, int p1) {
    this->parent1 = p0;
    this->parent2 = p1;
}

void Individual::setChromosomes(ChromosomeType chromosomes, float *fitness) {
    this->fitness = fitness;
    this->chromosome = chromosomes;
}


int Individual::getGeneration() const
{
    return generation;
}

int Individual::getCluster() const
{
    return cluster;
}

int Individual::getParent1() const
{
    return parent1;
}

int Individual::getParent2() const
{
    return parent2;
}

float* Individual::getFitness() const
{
    return fitness;
}

float Individual::getFitness(int index) const
{
    return fitness[index];
}

ChromosomeType Individual::getChromosome() const
{
    return chromosome;
}

void Individual::invert(float max, float min, int findex)
{
    float range = max - min;
    fitness[findex] = (max - fitness[findex]) / range;
}

void Individual::invert(float max, int findex)
{
    fitness[findex] = max - fitness[findex];
}
