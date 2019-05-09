#ifndef PARSER_H
#define PARSER_H

#include <QThread>
#include <QTextStream>
#include <QUrl>

#include "population.h"

class Parser: QObject
{
    Q_OBJECT

public:
    Parser();
    Population* parseFile(QUrl fileUrl);

protected:
    void run();

signals:
    void madeProgress(float prog);


private:
    QUrl fileUrl;
    Population* population;
};

#endif // PARSER_H
