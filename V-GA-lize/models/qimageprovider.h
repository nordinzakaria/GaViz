#ifndef QIMAGEPROVIDER_H
#define QIMAGEPROVIDER_H
#include <QQuickImageProvider>
#include <QPixmap>
#include "./models/vgalize.h"

class QImageProvider : public QQuickImageProvider
{


public:

    QImageProvider();
    QImageProvider(GAViz *engine);
    QImageProvider(GAViz *engine,QImage *image);
    QImageProvider(GAViz *engine,int width,int height,QImage::Format format);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    GAViz *m_engine;
    QImage *m_image;
};

#endif // QIMAGEPROVIDER_H
