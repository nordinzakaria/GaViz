#ifndef GAVIZEXCEPTION_H
#define GAVIZEXCEPTION_H

#include <QException>

class GAVizException : public QException
{
public:
    void raise() const override { throw *this; }
    GAVizException *clone() const override { return new GAVizException(*this); }
};

#endif // GAVIZEXCEPTION_H
