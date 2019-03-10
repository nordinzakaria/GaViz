#include "gaviz.h"
#include <iostream>

#include <QDebug>

Population* GAViz::population;

//GAViz::GAViz(QQmlApplicationEngine *engine) //: QObject(engine)
GAViz::GAViz()
{
    //this->engine = engine;
    parser = new Parser();
    QObject::connect((QObject*)parser, SIGNAL(madeProgress(float)),
                     (QObject*)this, SLOT(setProgress(float)));


    customPalette = new QPalette();
    customPalette->setColor(QPalette::Active, QPalette::Window, QColor("#000000"));
    customPalette->setColor(QPalette::Active, QPalette::WindowText, QColor("#ffffff"));
    customPalette->setColor(QPalette::Active, QPalette::Base, QColor("#000000"));
    customPalette->setColor(QPalette::Active, QPalette::AlternateBase, QColor("#0000ff"));  //QColor("#00ffff"));
    customPalette->setColor(QPalette::Inactive, QPalette::ToolTipBase, QColor("#000000"));
    customPalette->setColor(QPalette::Inactive, QPalette::ToolTipText, QColor("#ffffff"));
    customPalette->setColor(QPalette::Active, QPalette::Text,  QColor("#C8533A")); // QColor("#ffffff")); //
    customPalette->setColor(QPalette::Active, QPalette::ButtonText, QColor("#ffffff"));
    customPalette->setColor(QPalette::Active, QPalette::BrightText, QColor("#ffff00"));
    customPalette->setColor(QPalette::Active, QPalette::Light, QColor("#222222"));
    customPalette->setColor(QPalette::Active, QPalette::Midlight, QColor("#444444"));
    customPalette->setColor(QPalette::Active, QPalette::Button, QColor("#333333"));
    customPalette->setColor(QPalette::Active, QPalette::Mid, QColor("#dddddd"));
    customPalette->setColor(QPalette::Active, QPalette::Dark, QColor("#555555"));
    customPalette->setColor(QPalette::Active, QPalette::Shadow, QColor("#000000"));
}

void GAViz::run()
{
    GAViz::population = parser->parseFile(fileUrl);
    emit doneLoadingFile(true, GAViz::numPops(), GAViz::getNbObjectiveFunctions());
}

void GAViz::readGAFile(QUrl fileUrl)
{
    this->fileUrl = fileUrl;
    start();
}


QVariant GAViz::getMaxFitness(int findex) const
{
    float max = this->population[0].getMaxFitness(findex);
    for (int i=1; i<Population::getNbPop(); i++) {
        float val = this->population[i].getMaxFitness(findex);
        if (val > max)
            max = val;
    }

    return max;
}

QVariant GAViz::getMaxFitness(int pindex, int findex) const
{
    return this->population[pindex].getMaxFitness(findex);
}

QVariant GAViz::getMaxFitness(int pindex, int gindex, int findex) const
{
    Generation *gen = this->population[pindex].getGenerations(gindex);
    //qDebug() << "Finding max in gen " << gindex << "\n";
    float max = gen->getMaxFitness(findex);
    //qDebug() << "max was " << max << "\n";
    return max;
}

QVariant GAViz::getMinFitness(int findex) const
{
    float min = this->population[0].getMinFitness(findex);
    for (int i=1; i<Population::getNbPop(); i++) {
        float val = this->population[i].getMinFitness(findex);
        if (val < min)
            min = val;
    }

    return min;
}

QVariant GAViz::getMinFitness(int pindex, int findex) const
{
    return this->population[pindex].getMinFitness(findex);
}

QVariant GAViz::getMinFitness(int pindex, int gindex, int findex) const
{
    Generation *gen = this->population[pindex].getGenerations(gindex);
    return gen->getMinFitness(findex);
}
