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
//   -(k: k minus)
//   -(a: alpha)
//   -(g: gamma)
//   -(a: algorithm -> 0: kNN, 1: PCA + kNN, 2: PLS-DA + kNN)

using namespace chrono;

int main(int argc, char const *argv[]){
    if(argc != 7){
        cout << "Parameters should be: (i: input file), (o: output file), (k: k minus), (a: alpha), (g: gamma), (a: algorithm -> 0: kNN, 1: PCA + kNN, 2: PLS-DA + kNN)" << endl;
        return 0;
    }

    ifstream input(argv[1]);
    ofstream output(argv[2]);

    int kMinus = stoi(argv[3]);
    int alpha = stoi(argv[4]);
    int gamma = stoi(argv[5]);
    string method = argv[6];

    string inFileDir, line;
    int kMayus;

    input >> inFileDir >> kMayus;
    // skip the rest of the first line
    getline(input, line);

    for (int iter = 0; iter < kMayus; ++iter){
        vector<TimeEvent> timeTracker;
        //train or test input
        getline(input, line);
        stringstream lineStream(line);
        DigitImages imagesTrain, imagesTest;
        Matrix eigenVectorsPCA(alpha, vector<double>(DEFAULT_IMAGE_SIZE));
        Matrix eigenVectorsPLSDA(gamma, vector<double>(DEFAULT_IMAGE_SIZE));
        vector<double> eigenValuesPCA(alpha);
        vector<double> eigenValuesPLSDA(gamma);
        int niterPCA = 1000;
        int niterPLSDA = 1000;

        populateDigitImages(imagesTrain, imagesTest, inFileDir, lineStream);
        imagesTrain.getMeans();
        imagesTrain.calculateCentralized();
        imagesTrain.calculateCovariances();
        imagesTrain.calculateMeansLabels();
        imagesTest.calculateCentralizedTest(imagesTrain.means, (int)imagesTrain.images.size());

        //stores eigen vector and values with niter power method iterations
        PCA(imagesTrain.covariances, eigenVectorsPCA, eigenValuesPCA, alpha, niterPCA);
        for (int i = 0; i < alpha; ++i){
            output << scientific << sqrt(eigenValuesPCA[i]) << endl;
            // output << scientific << eigenValues[i] << endl;
        }

        PLSDA(imagesTrain, eigenVectorsPLSDA, eigenValuesPLSDA, gamma, niterPLSDA);
        for (int i = 0; i < gamma; ++i)
            output << scientific << eigenValuesPLSDA[i] << endl;

        vector<int> knnValues(imagesTest.centralized.size());
        vector<int> trueValues(imagesTest.centralized.size());
        switch(stoi(method)){
            case 0:{
                for (int i = 0; i < imagesTest.centralized.size(); ++i){
                    knnValues[i] = kNN(imagesTest.centralized[i], imagesTrain.centralized, kMinus, imagesTrain);
                    trueValues[i] = imagesTest.images[i].label;
                    // cout << "la imagen: " << i << " del kNN: " << knnValues[i] << " del label: " << trueValues[i] << endl;
                }
                string knnOut = argv[2];
                knnOut += "KNN";
                getStats(knnValues, trueValues, knnOut, timeTracker, kMinus, alpha, gamma, kMayus);
                break;
            }
            case 1:{
                TC tcTrainPCA, tcTestPCA;
                tcTrainPCA.init(eigenVectorsPCA, imagesTrain.centralized);
                tcTestPCA.init(eigenVectorsPCA, imagesTest.centralized);
                for (int i = 0; i < tcTestPCA.transformation.size(); ++i){
                    knnValues[i] = kNN(tcTestPCA.transformation[i], tcTrainPCA.transformation, kMinus, imagesTrain);
                    trueValues[i] = imagesTest.images[i].label;
                    // cout << "la imagen: " << i << " del kNN: " << knnValues[i] << " del label: " << trueValues[i] << endl;
                }
                string pcaOut = argv[2];
                pcaOut += "PCA";
                getStats(knnValues, trueValues, pcaOut, timeTracker, kMinus, alpha, gamma, kMayus);
                break;
            }
            case 2:{
                TC tcTrainPLSDA, tcTestPLSDA;
                tcTrainPLSDA.init(eigenVectorsPLSDA, imagesTrain.centralized);
                tcTestPLSDA.init(eigenVectorsPLSDA, imagesTest.centralized);
                for (int i = 0; i < tcTestPLSDA.transformation.size(); ++i){
                    knnValues[i] = kNN(tcTestPLSDA.transformation[i], tcTrainPLSDA.transformation, kMinus, imagesTrain);
                    trueValues[i] = imagesTest.images[i].label;
                    // cout << "la imagen: " << i << " del kNN: " << knnValues[i] << " del label: " << trueValues[i] << endl;
                }
                string plsOut = argv[2];
                plsOut += "PLS";
                getStats(knnValues, trueValues, plsOut, timeTracker, kMinus, alpha, gamma, kMayus);
                break;
            }
        }
    }
    input.close();
    output.close();
    return 0;
}
