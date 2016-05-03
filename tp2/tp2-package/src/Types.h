#ifndef Types_h
#define Types_h

#include "Imports.h"
#include "MatrixAlgorithms.h"

const int DEFAULT_IMAGE_SIDE_SIZE = 28;
const int DEFAULT_IMAGE_SIZE = DEFAULT_IMAGE_SIDE_SIZE * DEFAULT_IMAGE_SIDE_SIZE;
const int LABELS_QTY = 10;

/** Class representing one manuscript digit image **/
struct DigitImage {
    //faltaria poner label por defecto = -1
    int label;
    vector<double> pixels;
};

/** Class representing a smart container of DigitImage(s) **/
struct DigitImages {
    vector<int> labels;
    vector<double> means, labelYMeans;
    vector<DigitImage> images;
    Matrix centralized; // X
    Matrix centralizedPLSDA; // X
    Matrix covariances; // M = X^tX
    Matrix labelY;

    // -------- Initialization --------
    void init() {
        means = vector<double>(DEFAULT_IMAGE_SIZE, 0);
        labelYMeans = vector<double>(LABELS_QTY, 0);
    }

    // -------- Means --------
    void getMeans(){
        for (int i = 0; i < DEFAULT_IMAGE_SIZE; ++i)
            means[i] /= images.size();
        for (int i = 0; i < LABELS_QTY; ++i)
            labelYMeans[i] /= labelY.size();
    }

    // -------- Correlation --------
    void calculateCentralized(){
        for (int i = 0; i < images.size(); ++i)
            for (int j = 0; j < DEFAULT_IMAGE_SIZE; ++j){
                centralized[i][j] = (centralized[i][j] - means[j]) / sqrt(images.size() - 1);
                centralizedPLSDA[i][j] = (centralizedPLSDA[i][j] - means[j]) / sqrt(images.size() - 1);
            }
    }

    // -------- CorrelationTEST --------
    void calculateCentralizedTest(vector<double> &means, int samples){
        centralized = Matrix(images.size(), vector<double>(DEFAULT_IMAGE_SIZE));
        for (int i = 0; i < images.size(); ++i)
            for (int j = 0; j < DEFAULT_IMAGE_SIZE; ++j)
                centralized[i][j] = (images[i].pixels[j] - means[j]) / sqrt(samples - 1);
    }

    // -------- Covariance --------
    //XtX = M
    void calculateCovariances(){
        covariances = Matrix(DEFAULT_IMAGE_SIZE, vector<double>(DEFAULT_IMAGE_SIZE));
        for (int i = 0; i < DEFAULT_IMAGE_SIZE; ++i){
            for (int j = i; j < DEFAULT_IMAGE_SIZE; ++j){
                double sum = 0;
                for (int k = 0; k < images.size(); ++k){
                    sum += centralized[k][i] * centralized[k][j];
                }
                covariances[i][j] = sum;
                covariances[j][i] = sum;
            }
        }
    }

    // -------- MeansLabels --------
    void calculateMeansLabels(){
        for (int i = 0; i < labelY.size(); ++i)
            for (int j = 0; j < LABELS_QTY; ++j)
                labelY[i][j] = (labelY[i][j] - labelYMeans[j]) / sqrt(labelY.size() - 1);
    }
};

/** Class representing one manuscript digit image **/
struct TC {
    Matrix transformation;

    void init(Matrix &eigenVectors, Matrix &centralized){
        transformation = Matrix(centralized.size(), vector<double>(eigenVectors.size()));
        for (int i = 0; i < centralized.size(); ++i)
            for (int j = 0; j < eigenVectors.size(); ++j)
                transformation[i][j] = dotProduct(eigenVectors[j], centralized[i]);
    }
};

#endif