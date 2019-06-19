#ifndef QIMAGEPROVIDER_H
#define QIMAGEPROVIDER_H
#include <QQuickImageProvider>
#include <QObject>
#include <QImage>
#include "./models/vgalize.h"

class QImageProvider : public QObject,public QQuickImageProvider
{
    Q_OBJECT

public:
    static const QImage::Format DEFAULT_FORMAT = QImage::Format_RGBA64;

    QImageProvider(GAViz *engine);
    QImageProvider(GAViz *engine,QImage *image);
    QImageProvider(GAViz *engine,int width,int height,QImage::Format format);
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;
    void changeDimension(const int width,const int height,QImage::Format format);
    void changeDimension(const QSize *size, const QImage::Format format);



public slots:
    void handleFileLoaded();

private:
    GAViz *mEngine;
    QImage *mImage;

};

#endif // QIMAGEPROVIDER_H
