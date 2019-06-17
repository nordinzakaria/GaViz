#include "qimageprovider.h"

QImageProvider::QImageProvider(GAViz *engine)
    : QQuickImageProvider(QQuickImageProvider::Image),m_engine(engine)
{}
QImageProvider::QImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
}


QImage QImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    /**
     * ask the engine(GAViz) to create a Image of all individuals
     */
    QImage image = m_engine->getImageIndividuals();
    *size = image.size();
    return image;
}


