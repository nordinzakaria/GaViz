#include "qimageprovider.h"
#include <iostream>

QImageProvider::QImageProvider(GAViz *engine)
    : QQuickImageProvider(QQuickImageProvider::Image),mEngine(engine)
{

    //! Empty Image
    mImage = new QImage(0,0,QImage::Format_RGBA64);

    connect(engine,
            &GAViz::doneLoadingFile,
            this,
            &QImageProvider::handleFileLoaded
            );

}

QImageProvider::QImageProvider(GAViz *engine,QImage *image)
    : QQuickImageProvider(QQuickImageProvider::Image),mEngine(engine),mImage(image)
{

    connect(engine,
            &GAViz::doneLoadingFile,
            this,
            &QImageProvider::handleFileLoaded
            );
}

QImageProvider::QImageProvider(GAViz *engine,int width,int height,QImage::Format format)
    : QQuickImageProvider(QQuickImageProvider::Image),mEngine(engine)
{
    mImage = new QImage(width,height,format);
    connect(engine,
            &GAViz::doneLoadingFile,
            this,
            &QImageProvider::handleFileLoaded
            );
}

/*!
 * \fn QImageProvider::requestImage
 * \param const QString &id
 * \param QSize *size
 * \param const QSize &requestedSize
 * \return QImage filled with datas
 *
 * The function is called in QML when an Image need to be updated.
 * It fill the QImage with GAViz datas and send it to the QML.
 *
 */
QImage QImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{

    //! The id should contain the minScore
    float minScore = id.toFloat();

    //! Fill the Image
    mEngine->fillImageIndividuals(mImage,minScore);

    if (requestedSize.isValid()){
        mImage->scaled(requestedSize.width(),requestedSize.height(),Qt::KeepAspectRatio,Qt::SmoothTransformation);
    }

    *size = mImage->size();

    return *mImage;
}

/*!
 * \fn QImageProvider::handleFileLoaded
 *
 * The function is called when GAViz has finished to load the data file.
 * When datas are loaded we can set the QImage bounds to match the exact number of generation
 * and individuals in each generation.
 *
 */
void QImageProvider::handleFileLoaded()
{

    int generations = mEngine->getNbGenerations().toInt();  //! How much generations
    int individuals = mEngine->getMaxNbIndPerGeneration().toInt(); //! How much individuals for a generation

    QSize size = QSize(individuals,generations);

    /**
     *  If the QImage is nullptr, it will be instanciated with the given QSize.
     *  If the QImage is allready instanciated but have a different size than requested,
     *  it will "realloc" the image with the good size
     */
    if (mImage == nullptr || size != mImage->size())
        changeDimension(&size,QImage::Format_RGBA64);

    //! The Image is not nullptr
    Q_ASSERT(mImage != nullptr);
    //! The Image have the good size
    Q_ASSERT(size == mImage->size());
}


/*!
 * \fn QImageProvider::changeDimension
 * \param int width
 * \param int height
 * \param QImage::Format format
 *
 * \brief Change the bounds of the current Qimage.
 *
 * If the QImage wasn't instanciated (nullptr) then instanciate it with the given QSize and QImage::Format.
 * If the QImage was instanciated but the given size is equal to the actual QImage's size,
 * nothing will append because there is no need to change bounds.
 * If m_image was instanciated and the given size is diffenrent than the actual QImage's size,
 * the function delete the old QImage and create a new one with the given QSize and QImage::Format.
 *
 */
void QImageProvider::changeDimension(const int width,const int height,QImage::Format format)
{
    QSize size = QSize(width,height);
    changeDimension(&size,format);
}

/*!
 * \fn QImageProvider::changeDimension
 * \param QSize *size
 * \param QImage::Format format
 *
 * \brief Change the bounds of the current Qimage.
 *
 * If the QImage wasn't instanciated (nullptr) then instanciate it with the given QSize and QImage::Format.
 * If the QImage was instanciated but the given size is equal to the actual QImage's size,
 * nothing will append because there is no need to change bounds.
 * If m_image was instanciated and the given size is diffenrent than the actual QImage's size,
 * the function delete the old QImage and create a new one with the given QSize and QImage::Format.
 *
 */
void QImageProvider::changeDimension(const QSize *size,const QImage::Format format)
{
    QSize newSize = *size;

    if (mImage == nullptr){    //! If the image is nullptr we create it
        mImage = new QImage(newSize,format);
    }else{                      //! If the image is allready created
        QSize oldSize = mImage->size();

        //! If dimensions are the same there is no need to change the image
        if (oldSize != newSize){

            QImage *oldImage = mImage;
            mImage = new QImage(newSize,format);

            //! To ensure that we don't delete the new image
            Q_ASSERT(oldImage != mImage);

            //! Should be impossible, prior to the if statement.
            Q_ASSERT(oldImage != nullptr);

            delete oldImage;
        }
    }
}


