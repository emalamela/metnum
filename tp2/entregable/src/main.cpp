//Compile: g++ -o tp main.cpp -std=c++11
//Run con tests provistos ./tp tests/test1.in .......
#include "Algorithms.h"
#include "Tests.h"
#include "Types.h"
#include "InputProcessor.h"
#include "Print.h"
#include "MatrixAlgorithms.h"
#include "Stats.h"

// --- Input arguments ---
//   -(i: input file)
//   -(o: output file)
//   -(a: algorithm -> 0: kNN, 1: PCA + kNN, 2: PLS-DA + kNN)

int main(int argc, char const *argv[]){
    if(argc != 4){
        cout << "Parameters should be: (i: input file), (o: output file), (a: algorithm -> 0: kNN, 1: PCA + kNN, 2: PLS-DA + kNN, 3: Kaggle)" << endl;
        return 0;
    }

    ifstream input(argv[1]);
    string method = argv[3];

    if(method != "3"){
        ofstream output(argv[2]);
        string inFileDir, line;
        int kMinus, alpha, gamma, kMayus;

        input >> inFileDir >> kMinus >> alpha >> gamma >> kMayus;
        // skip the rest of the first line
        getline(input, line);

        for (int iter = 0; iter < kMayus; ++iter){
            //train or test input
            getline(input, line);
            stringstream lineStream(line);
            DigitImages imagesTrain, imagesTest;
            Matrix eigenVectorsPCA(alpha, vector<double>(DEFAULT_IMAGE_SIZE));
            Matrix eigenVectorsPLSDA(gamma, vector<double>(DEFAULT_IMAGE_SIZE));
            vector<double> eigenValuesPCA(alpha);
            vector<double> eigenValuesPLSDA(gamma);
            int niterPCA = 2000;
            int niterPLSDA = 2000;

            populateDigitImages(imagesTrain, imagesTest, inFileDir, lineStream);
            imagesTrain.getMeans();
            imagesTrain.calculateCentralized();
            imagesTrain.calculateCovariances();
            imagesTrain.calculateMeansLabels();
            imagesTest.calculateCentralizedTest(imagesTrain.means, (int)imagesTrain.images.size());

            //stores eigen vector and values with niter power method iterations
            PCA(imagesTrain.covariances, eigenVectorsPCA, eigenValuesPCA, alpha, niterPCA);
            for (int i = 0; i < alpha; ++i)
                output << scientific << eigenValuesPCA[i] << endl;
            PLSDA(imagesTrain, eigenVectorsPLSDA, eigenValuesPLSDA, gamma, niterPLSDA);
            for (int i = 0; i < gamma; ++i)
                output << scientific << eigenValuesPLSDA[i] << endl;

            map<string, int> timeTracker;
            AwesomeStatistic stat;
            vector<int> knnValues(imagesTest.centralized.size());
            vector<int> trueValues(imagesTest.centralized.size());
            switch(stoi(method)){
                case 0:{
                    for (int i = 0; i < imagesTest.centralized.size(); ++i){
                        vector<int> kMin = {kMinus}, labelRes;
                        kNN(imagesTest.centralized[i], imagesTrain.centralized, kMin, labelRes, imagesTrain.labels);
                        knnValues[i] = labelRes[0];
                        trueValues[i] = imagesTest.labels[i];
                    }
                    string knnOut = argv[2];
                    knnOut += "KNN";
                    getStats(knnValues, trueValues, knnOut, timeTracker, kMinus, alpha, gamma, kMayus, iter, stat);
                    break;
                }
                case 1:{
                    TC tcTrainPCA, tcTestPCA;
                    tcTrainPCA.init(eigenVectorsPCA, imagesTrain.centralized);
                    tcTestPCA.init(eigenVectorsPCA, imagesTest.centralized);
                    for (int i = 0; i < tcTestPCA.transformation.size(); ++i){
                        vector<int> kMin = {kMinus}, labelRes;
                        kNN(tcTestPCA.transformation[i], tcTrainPCA.transformation, kMin, labelRes, imagesTrain.labels);
                        knnValues[i] = labelRes[0];
                        trueValues[i] = imagesTest.labels[i];
                    }
                    string pcaOut = argv[2];
                    pcaOut += "PCA";
                    getStats(knnValues, trueValues, pcaOut, timeTracker, kMinus, alpha, gamma, kMayus, iter, stat);
                    break;
                }
                case 2:{
                    TC tcTrainPLSDA, tcTestPLSDA;
                    tcTrainPLSDA.init(eigenVectorsPLSDA, imagesTrain.centralized);
                    tcTestPLSDA.init(eigenVectorsPLSDA, imagesTest.centralized);
                    for (int i = 0; i < tcTestPLSDA.transformation.size(); ++i){
                        vector<int> kMin = {kMinus}, labelRes;
                        kNN(tcTestPLSDA.transformation[i], tcTrainPLSDA.transformation, kMin, labelRes, imagesTrain.labels);
                        knnValues[i] = labelRes[0];
                        trueValues[i] = imagesTest.labels[i];
                    }
                    string plsOut = argv[2];
                    plsOut += "PLS";
                    getStats(knnValues, trueValues, plsOut, timeTracker, kMinus, alpha, gamma, kMayus, iter, stat);
                    break;
                }
            }
        }
        output.close();
    }
    else{
        string inFileDir, line;
        int alpha, gamma, kPCA, kPLSDA;

        input >> inFileDir >> alpha >> gamma >> kPCA >> kPLSDA;

        string outPCA = argv[2], outPLSDA = argv[2];
        outPCA += "PCA.out";
        outPLSDA += "PLSDA.out";
        ofstream outputPCA(outPCA);
        ofstream outputPLSDA(outPLSDA);

        DigitImages imagesTrain, imagesTest;
        Matrix eigenVectorsPCA(alpha, vector<double>(DEFAULT_IMAGE_SIZE));
        Matrix eigenVectorsPLSDA(gamma, vector<double>(DEFAULT_IMAGE_SIZE));
        vector<double> eigenValuesPCA(alpha);
        vector<double> eigenValuesPLSDA(gamma);
        int niterPCA = 2000;
        int niterPLSDA = 2000;

        populateKaggle(imagesTrain, imagesTest, inFileDir);
        imagesTrain.getMeans();
        imagesTrain.calculateCentralized();
        imagesTrain.calculateCovariances();
        imagesTrain.calculateMeansLabels();
        imagesTest.calculateCentralizedTest(imagesTrain.means, (int)imagesTrain.images.size());

        TC tcTrainPCA, tcTestPCA, tcTrainPLSDA, tcTestPLSDA;
        PCA(imagesTrain.covariances, eigenVectorsPCA, eigenValuesPCA, alpha, niterPCA);
        tcTrainPCA.init(eigenVectorsPCA, imagesTrain.centralized);
        tcTestPCA.init(eigenVectorsPCA, imagesTest.centralized);
        outputPCA << "ImageId,"<< "Label"<< endl;
        for (int i = 0; i < tcTestPCA.transformation.size(); ++i){
            vector<int> kMin = {kPCA}, labelRes;
            kNN(tcTestPCA.transformation[i], tcTrainPCA.transformation, kMin, labelRes, imagesTrain.labels);
            outputPCA << i+1 <<","<< labelRes[0] << endl;
        }
        PLSDA(imagesTrain, eigenVectorsPLSDA, eigenValuesPLSDA, gamma, niterPLSDA);
        tcTrainPLSDA.init(eigenVectorsPLSDA, imagesTrain.centralized);
        tcTestPLSDA.init(eigenVectorsPLSDA, imagesTest.centralized);
        outputPLSDA << "ImageId,"<< "Label"<< endl;
        for (int i = 0; i < tcTestPLSDA.transformation.size(); ++i){
            vector<int> kMin = {kPLSDA}, labelRes;
            kNN(tcTestPLSDA.transformation[i], tcTrainPLSDA.transformation, kMin, labelRes, imagesTrain.labels);
            outputPLSDA << i+1 <<","<< labelRes[0] << endl;
        }
        outputPCA.close();
        outputPLSDA.close();
    }
    input.close();
    return 0;
}
