#ifndef INDIVIDUAL_H
#define INDIVIDUAL_H

#include <QString>
#include <QObject>
#include <QVariant>

union ChromosomeType {
    float *arrayf;
    int *arrayI;
    double *arrayD;
    char *arrayC;
    QString *arrayS;
};

enum ChromosomeDataType { FLOAT, INTEGER, DOUBLE, CHAR, STRING };

class Individual : public QObject
{
    Q_OBJECT

public:
    Individual();
    Individual(int generation, int cluster, int parent1, int parent2, float *fitness, ChromosomeType chromosome, int rank);

    enum Property {
        Generation = Qt::UserRole + 1,
        Cluster,
        Parent1,
        Parent2,
        Fitness,
        Rank,
        NumGenes,
        Chromosome
    };
    Q_ENUMS(Property)

    void setNumFitness(int f);
    void setNumGenes(int ng);
    void setGeneration(int g);
    void setCluster(int c);
    void setParents(int p0, int p1);
    void setRank(int rank);
    void setFitness(float *f);
    void setFitness(float f, int index);
    void setChromosomes(ChromosomeType chromosomes, float *fitness);

    int getNumFitness() const;
    int getNumGenes() const;
    int getGeneration() const;
    int getCluster() const;
    int getParent1() const;
    int getParent2() const;
    int getRank() const;
    float getFitness(int index) const;
    float* getFitness() const;
    ChromosomeType getChromosome() const;
    void invert(float max, float min, int findex);
    void invert(float max, int findex);

    QVariant getGene(int index) {
        switch (chrtype)
        {
        case ChromosomeDataType::FLOAT:
            return chromosome.arrayf[index];
        case ChromosomeDataType::CHAR:
            return chromosome.arrayC[index];
        case ChromosomeDataType::DOUBLE:
            return chromosome.arrayD[index];
        case ChromosomeDataType::STRING:
            return chromosome.arrayS[index];
        case ChromosomeDataType::INTEGER:
            return chromosome.arrayI[index];
        }

        return -1;
    }

    static void setChrType(ChromosomeDataType chrtype)
    {
        Individual::chrtype = chrtype;
    }

    static void setGeneMax(QVariant v)
    {
        Individual::maxgene = v;
    }

    static QVariant getGeneMax()
    {
        return Individual::maxgene;
    }

    static void setGeneMin(QVariant v)
    {
        Individual::mingene = v;
    }

    static QVariant getGeneMin()
    {
        return Individual::mingene;
    }

private:
    int generation;
    int cluster;
    int parent1;
    int parent2;
    float *fitness;
    int numFitness;
    int rank;
    int numgenes;
    ChromosomeType chromosome;

protected:
    static ChromosomeDataType chrtype;
    static QVariant maxgene;
    static QVariant mingene;
};

#endif // INDIVIDUAL_H
