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
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

private:
    GAViz *m_engine;
};

#endif // QIMAGEPROVIDER_H
