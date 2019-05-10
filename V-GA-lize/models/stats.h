#ifndef STATS_H
#define STATS_H

#include <QObject>

class Stats: public QObject
{
    Q_OBJECT
public:

    enum Property {
        AVERAGE,
        MIN,
        MAX,
        STDDEV
    };
    Q_ENUMS(Property)


    Q_PROPERTY(float average READ average WRITE setAverage NOTIFY averageChanged)
    Q_PROPERTY(float min READ min WRITE setMin NOTIFY minChanged)
    Q_PROPERTY(float max READ max WRITE setMax NOTIFY maxChanged)
    Q_PROPERTY(float stddev READ stddev WRITE setStddev NOTIFY stddevChanged)

    void setAverage(float average)
        {
            m_average = average;
            emit averageChanged(average);
        }

    float average() const
        { return m_average; }

    void setMin(float min)
        {
            m_min = min;
            emit minChanged(min);
        }

    float min() const
        { return m_min; }

    void setMax(float max)
        {
            m_max = max;
            emit maxChanged(max);
        }

    float max() const
        { return m_max; }

    void setStddev(float stddev)
        {
            m_stddev = stddev;
            emit stddevChanged(stddev);
        }

    float stddev() const
        { return m_stddev; }

    signals:
        void averageChanged(float);
        void minChanged(float);
        void maxChanged(float);
        void stddevChanged(float);

    private:
        float m_average;
        float m_min;
        float m_max;
        float m_stddev;
};

#endif // STATS_H
