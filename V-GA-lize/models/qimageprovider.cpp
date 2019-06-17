#include "qimageprovider.h"
#include <iostream>

QImageProvider::QImageProvider(GAViz *engine)
    : QQuickImageProvider(QQuickImageProvider::Image),m_engine(engine)
{
    m_image = nullptr;
}

QImageProvider::QImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{
    m_image = nullptr;
}

QImageProvider::QImageProvider(GAViz *engine,QImage *image)
    : QQuickImageProvider(QQuickImageProvider::Image),m_engine(engine),m_image(image)
{}

QImageProvider::QImageProvider(GAViz *engine,int width,int height,QImage::Format format)
    : QQuickImageProvider(QQuickImageProvider::Image),m_engine(engine)
{
    m_image = new QImage(width,height,format);
}

QImage QImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    //TODO : parse QString to get minScore
    float minScore = id.toFloat();

    /**
     * ask the engine(GAViz) to fill a Image of all individuals
     */

    try {
        m_engine->fillImageIndividuals(m_image,minScore);
    } catch (std::bad_exception &) {
        std::cout << "exception occured in fillImage" << std::endl;
        std::cout << "image is not updated" << std::endl;
    }

    *size = m_image->size();
    return *m_image;
}


