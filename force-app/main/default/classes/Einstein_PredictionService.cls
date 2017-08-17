public class Einstein_PredictionService {
    
    // Base URL for the PredictionService
    private static String BASE_URL = 'https://api.einstein.ai/v2';
    
    private String DATASETS = BASE_URL + '/vision/datasets';
    private String EXAMPLES = '/examples';
    private String TRAIN = BASE_URL + '/vision/train';
    private String MODELS = '/vision/models';
    private String PREDICT = BASE_URL + '/vision/predict';
    private String API_USAGE = BASE_URL + '/apiusage';
    private static String OAUTH2 = BASE_URL + '/oauth2/token';
    
    private boolean isExecuting = false;
    private String bearerToken = '';
    public Integer httpStatusCode = 0;
    private Types typeEnum;
    private String typeString;
    public String baseUrl;

    public enum Types {
        IMAGE,
        IMAGE_MULTI_LABEL,
        SENTIMENT,
        INTENT
    }
    
    /**
* <p>Create a new object of type Einstein_PredictionService.</p>
* 
* <p>The Einstein_PredictionService is the foundation for communicating with the Salesforce Einstein Prediction Service.
* 
*/
    public Einstein_PredictionService(Einstein_PredictionService.Types typeEnum) {
        this.bearerToken = getAccessToken();
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }
    
    /**
* <p>Create a new object of type Einstein_PredictionService.</p>
* 
* <p>The Einstein_PredictionService is the foundation for communicating with the Salesforce Einstein Prediction Service.
* 
* @param bearerToken
* A valid Bearer token
*/
    public Einstein_PredictionService(String bearerToken, Einstein_PredictionService.Types typeEnum) {
        this.bearerToken = bearerToken;
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }
    

    /**
* Creates a new dataset with images from a remote zip file (async call).
* @param url
* The remote URL of the to be trained image.
* @return
* @
*/
    public Einstein_Dataset createDatasetFromUrlAsync(String url) {
        System.debug('Starting createDatasetFromUrlAsync call from URL ' + url + ' for type ' + typeString + '.');
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/upload', parts.build());
        client.isPost(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createDatasetFromUrlAsync has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New dataset with id ' + dataset.id + ' has been created.');
            return dataset;
        }
        return null;
    }

    /**
* Creates a new dataset with images from a remote zip file (sync).
* @param url
* The remote URL of the to be trained image.
* @return
* @
*/
    private Einstein_Dataset createDatasetFromUrlSync(String url) {
        System.debug('Starting createDatasetFromUrlSync call from URL ' + url + ' for type ' + typeString + '.');
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/upload/sync', parts.build());
        client.isPost(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createDatasetFromUrlSync has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New dataset with id ' + dataset.id + ' has been created.');
            return dataset;
        }
        return null;
    }
    
    /**
* Gets an existing Einstein_Dataset.
* @param id
* The id of the Einstein_Dataset that needs to be fetched.
* @return
* @
*/
    public Einstein_Dataset getDataset(Long id) {
        if (id==0) {
            throw new Einstein_NoValuesException('datasetId');
        }
        System.debug('Starting getDataset call with parameter ' + id);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + id);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getDataset has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('Dataset has been read.');
            return dataset;
        }
        return null;
    }
    
    /**
* Gets all Einstein_Datasets of the authenticated user.
* @return
* An array of all Einstein_Datasets
*/
    public Einstein_Dataset[] getDatasets() {
        System.debug('Starting getDatasets call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getDatasets has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Dataset[] datasets = (Einstein_Dataset[])client.getParser().readValueAs(Einstein_Dataset[].class);
            System.debug('Datasets have been read.');
            return datasets;
        }
        return null;
    }
    
    /**
* Deletes an existing dataset.
* @param dataset
* The Einstein_Dataset that should be deleted.
* @return
* True if the deletion was successful.
*/
    public boolean deleteDataset(Einstein_Dataset dataset) {
        return deleteDataset(dataset.id);
    }
    
    /**
* Deletes an existing dataset.
* @param id
* The id of the Einstein_Dataset that should be deleted.
* @return
* True if the deletion was successful.
*/
    public boolean deleteDataset(Long id) {
        System.debug('Starting deleteDataset call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + id);
        client.isDelete(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call deleteDataset has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            System.debug('Dataset ' + id + ' has been deleted.');
            return true;
        }
        return false;
    }
    
    /**
* Adds new image examples for the predictive vision training.
* @param datasetId
* The id of the Einstein_Dataset to which the image should be added.
* @param name
* The name of the example.
* @param fileBlob
* The blog of the to be trained image.
* @return
* @
*/
    public Einstein_Example createExample(Long datasetId, String name, Long labelId, Blob fileBlob) {
        System.debug('Starting createExample call from blob');
        Einstein_HttpBodyPartExample parts = new Einstein_HttpBodyPartExample(name, labelId, EncodingUtil.base64Encode(fileBlob));
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/examples', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.isPost(true);
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createExample from blob has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Example example = (Einstein_Example)client.getParser().readValueAs(Einstein_Example.class);
            System.debug('New example with id ' + example.id + ' has been created.');
            return example;
        }
        return null;
    }
    
    /**
* Adds new image examples for the predictive vision training via a remote zip file.
* @param datasetId
* The id of the Einstein_Dataset to which the image should be added.
* @param url
* The remote URL of the to be trained image.
* @return
* @
*/
    public Einstein_Dataset createExamplesFromUrl(Long datasetId, String url) {
        System.debug('Starting createExamplesFromUrl call from URL ' + url);
        Einstein_HttpBodyPartDatasetUrl parts = new Einstein_HttpBodyPartDatasetUrl(url, this.typeString);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/upload', parts.build());
        client.isPut(true);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call createExampleFromUrl has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Dataset dataset = (Einstein_Dataset)client.getParser().readValueAs(Einstein_Dataset.class);
            System.debug('New examples for dataset with id ' + dataset.id + ' have been created.');
            return dataset;
        }
        return null;
    }
    
    /**
* Gets an array of all Einstein_Examples that are associated with the given Dataset.
* @param dataset
* The Einstein_Dataset to which the Einstein_Examples are associated.
* @return
* @
*/
    public Einstein_Example[] getExamples(Einstein_Dataset dataset) {
        return getExamples(dataset.id);
    }
    
    /**
* Gets an array of all Einstein_Examples that are associated with the given Einstein_Dataset.
* @param datasetId
* The id of the Einstein_Dataset to which the Einstein_Examples are associated.
* @return
* @
*/
    public Einstein_Example[] getExamples(Long datasetId) {
        System.debug('Starting getExamples call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/examples');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getExamples has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Example[] examples = (Einstein_Example[])client.getParser().readValueAs(Einstein_Example[].class);
            System.debug('Examples have been read.');
            return examples;
        }
        return null;
    }
    
    /**
* Starts the training of a Einstein_Dataset.
* @param dataset
* The Einstein_Dataset that should be trained.
* @param name
* The name of the Einstein_Dataset.
* @param epochs
* Optional. The number of training iterations, valid values are between 1-100. Set to 0 if you want to use the default.
* @param learningRate
* Optional. The learning rate, valid values are betweed 0.0001 and 0.01. Set to 0 if you want to use the default.
* @return
* @
*/
    public Einstein_Model trainDataset(Einstein_Dataset dataset, String name, Integer epochs, Decimal learningRate, String trainParams) {
        return trainDataset(dataset.id, name, epochs, learningRate, trainParams);
    }
    
    /**
* Starts the training of a Einstein_Dataset.
* @param datasetId
* The Einstein_Dataset id that should be trained.
* @param name
* The name of the Einstein_Dataset.
* @param epochs
* Optional. The number of training iterations, valid values are between 1-100. Set to 0 if you want to use the default.
* @param learningRate
* Optional. The learning rate, valid values are betweed 0.0001 and 0.01. Set to 0 if you want to use the default.
*/
    public Einstein_Model trainDataset(Long datasetId, String name, Integer epochs, Decimal learningRate, String trainParams) {
        Einstein_Dataset dataset = getDataset(datasetId);
        if (dataset != null) {
            if (dataset.totalExamples>0) {
                System.debug('Starting trainDataset call with name ' + name);
                Einstein_HttpBodyPartTraining parts = new Einstein_HttpBodyPartTraining(datasetId, name, epochs, learningRate, trainParams);
                Einstein_HttpClient client = new Einstein_HttpClient(this, '/train', parts.build());
                System.debug('Target URL is ' + client.getUrl());
                client.execute();
                while(isExecuting()) {
                    System.debug('Status is: ' + isExecuting());
                }
                System.debug('Call trainDataset has been executed.');
                if (client.isError()) {
                    handleError(client.getStatusCode(), client.getResponseError());
                } else {
                    Einstein_Model model = (Einstein_Model)client.getParser().readValueAs(Einstein_Model.class);
                    System.debug('New Model with id ' + model.modelId + ' has been created.');
                    return model;
                }
            } else {
                System.debug('The dataset with id ' + datasetId + ' has no configured examples.');
            }
        }
        return null;
    }
    
    /**
* Fetches the model for the given id.
* @param modelId
* The id of the model that needs to be fetched.
* @return
* @
*/
    public Einstein_Model getModel(String modelId) {
        System.debug('Starting getModel call with parameter ' + modelId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/train/' + modelId);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModel has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Model model = (Einstein_Model)client.getParser().readValueAs(Einstein_Model.class);
            System.debug('Model status has been read.');
            return model;
        }
        return null;
    }
    
    /**
* Gets the learning curve of a model.
* @param modelMetricsId
* The model id for which the learning curve should be fetched.
* @return
* @
*/
    public Einstein_ModelLearningCurve[] getModelLearningCurve(String modelMetricsId) {
        System.debug('Starting getModelLearningCurve call with parameter ' + modelMetricsId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/models/' + modelMetricsId + '/lc');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModelLearningCurve has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_ModelLearningCurve[] modelLearningCurve = (Einstein_ModelLearningCurve[])client.getParser().readValueAs(Einstein_ModelLearningCurve[].class);
            System.debug('ModelLearningCurve has been read.');
            return modelLearningCurve;
        }
        return null;
    }
    
    /**
* Gets the metrics of a model.
* @param modelMetricsId
* The model id for which the metrics should be fetched.
* @return
* @
*/
    public Einstein_ModelMetrics getModelMetrics(String modelMetricsId) {
        System.debug('Starting getModelMetrics call with parameter ' + modelMetricsId);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/models/' + modelMetricsId);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModelMetrics has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_ModelMetrics modelMetrics = (Einstein_ModelMetrics)client.getParser().readValueAs(Einstein_ModelMetrics.class);
            System.debug('ModelMetrics have been read.');
            return modelMetrics;
        }
        return null;
    }
    
    /**
* Gets all trained Einstein_Models that are trained for the given Einstein_Dataset.
* @param dataset
* The Einstein_Dataset to which the Einstein_Models are assigned.
* @return
* @
*/
    public Einstein_Model[] getModels(Einstein_Dataset dataset) {
        return getModels(dataset.id);
    }
    
    /**
* Gets all trained Einstein_Models that are trained for the given Einstein_Dataset.
* @param datasetId
* The Einstein_Dataset id to which the Einstein_Models are assigned.
* @return
* @
*/
    public Einstein_Model[] getModels(Long datasetId) {
        System.debug('Starting getModels call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/datasets/' + datasetId + '/models');
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getModels has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_Model[] models = (Einstein_Model[])client.getParser().readValueAs(Einstein_Model[].class);
            System.debug('Models have been read.');
            return models;
        }
        return null;
    }

    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param model
* The Einstein_Model that should be used for the prediction.
* @param base64
* The image that should be predicted.

* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictIntent(Einstein_Model model, String text, Integer numResults, String sampleId) {
        return predictIntent(model.modelId, text, numResults, sampleId);
    }
    
    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param modelId
* The Einstein_Model id that should be used for the prediction.
* @param base64
* The image that should be predicted.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictIntent(String modelId, String text, Integer numResults, String sampleId) {
        System.debug('Starting predict intent call with model ' + modelId);
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, text, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.DOCUMENT);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/intent', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        return null;
    }

    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param model
* The Einstein_Model that should be used for the prediction.
* @param base64
* The image that should be predicted.

* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictSentiment(Einstein_Model model, String text, Integer numResults, String sampleId) {
        return predictSentiment(model.modelId, text, numResults, sampleId);
    }
    
    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param modelId
* The Einstein_Model id that should be used for the prediction.
* @param base64
* The image that should be predicted.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictSentiment(String modelId, String text, Integer numResults, String sampleId) {
        System.debug('Starting predict sentiment call with model ' + modelId);
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, text, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.DOCUMENT);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/sentiment', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        return null;
    }
    
    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param model
* The Einstein_Model that should be used for the prediction.
* @param base64
* The image that should be predicted.

* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageBase64(Einstein_Model model, String base64, Integer numResults, String sampleId) {
        return predictImageBase64(model.modelId, base64, numResults, sampleId);
    }
    
    /**
* Predicts the association of the given image in Base64 format to a trained model.
* @param modelId
* The Einstein_Model id that should be used for the prediction.
* @param base64
* The image that should be predicted.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageBase64(String modelId, String base64, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for base64');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, base64, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        return null;
    }
    
    /**
* Predicts the association of the given image in a file blob to a trained model.
* @param model
* The Einstein_Model that should be used for the prediction.
* @param fileBlob
* The image blob for the prediction.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageBlob(Einstein_Model model, Blob fileBlob, Integer numResults, String sampleId) {
        return predictImageBlob(model.modelId, fileBlob, numResults, sampleId);
    }
    
    /**
* Predicts the association of the given image on the local file system to a trained model.
* @param modelId
* The Model id that should be used for the prediction.
* @param fileBlob
* The image blob for the prediction.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageBlob(String modelId, Blob fileBlob, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for blob');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, EncodingUtil.base64Encode(fileBlob), numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.BASE64);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        return null;
    }
    
    /**
* Predicts the association of the given image on a remote url to a trained model.
* @param model
* The Einstein_Model that should be used for the prediction.
* @param url
* The absolute url of the image.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageUrl(Einstein_Model model, String url, Integer numResults, String sampleId) {
        return predictImageUrl(model.modelId, url, numResults, sampleId);
    }
    
    /**
* Predicts the association of the given image on a remote url to a trained model.
* @param modelId
* The Model id that should be used for the prediction.
* @param url
* The absolute url of the image.
* @param sampleId
* Optional. A string that gets returned as an association with the predicted image.
* @return
* @
*/
    public Einstein_PredictionResult predictImageUrl(String modelId, String url, Integer numResults, String sampleId) {
        System.debug('Starting predict call with model ' + modelId + ' for url');
        Einstein_HttpBodyPartPrediction parts = new Einstein_HttpBodyPartPrediction(modelId, url, numResults, sampleId, Einstein_HttpBodyPartPrediction.Types.URL);
        Einstein_HttpClient client = new Einstein_HttpClient(this, '/predict', parts.build());
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while(isExecuting()) {
            System.debug('Status is: ' + isExecuting());
        }
        System.debug('Call predict has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_PredictionResult predictions = (Einstein_PredictionResult)client.getParser().readValueAs(Einstein_PredictionResult.class);
            System.debug('Image has been predicted.');
            return predictions;
        }
        return null;
    }
    
    /**
* Fetches data about the API usage of the authenticated PredictionService.
* @return
* An array of all Einstein_ApiUsage elements.
*/
    public Einstein_ApiUsage[] getApiUsage() {
        System.debug('Starting getApiUsage call');
        Einstein_HttpClient client = new Einstein_HttpClient(this, API_USAGE);
        System.debug('Target URL is ' + client.getUrl());
        client.execute();
        while (isExecuting()) {
            System.debug('Status is: ' + isExecuting() );
        }
        System.debug('Call getApiUsage has been executed.');
        if (client.isError()) {
            handleError(client.getStatusCode(), client.getResponseError());
        } else {
            Einstein_ApiUsage[] apiUsage = (Einstein_ApiUsage[])client.getParser().readValueAs(Einstein_ApiUsage[].class);
            System.debug('API usage has been fetched.');
            return apiUsage;
        }
        return null;
    }
    
    /**
* 
* @return
*/
    public boolean isExecuting() {
        return isExecuting;
    }
    
    /**
* 
* @param isExecuting
*/
    public void isExecuting(boolean isExecuting) {
        this.isExecuting = isExecuting;
    }
    
    /**
* 
* @param message
*/
    private void handleError(Integer statusCode, String message) {
        httpStatusCode = statusCode;
        System.debug(LoggingLevel.Error, 'Response finished with Error: ' + message);
    }

    public void setType(Types typeEnum) {
        this.typeEnum = typeEnum;
        this.baseUrl = resolveBaseUrl();
        this.typeString = resolveType();
    }
    
    private String resolveType() {
        if (this.typeEnum == Einstein_PredictionService.Types.IMAGE) {
            return 'image';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_MULTI_LABEL) {
            return 'image-multi-label';
        } else if (this.typeEnum == Einstein_PredictionService.Types.SENTIMENT) {
            return 'sentiment';
        } else if (this.typeEnum == Einstein_PredictionService.Types.INTENT) {
            return 'intent';
        }
        return '';
    }

    private String resolveBaseUrl() {
        if (this.typeEnum == Einstein_PredictionService.Types.IMAGE) {
            return BASE_URL + '/vision';
        } else if (this.typeEnum == Einstein_PredictionService.Types.IMAGE_MULTI_LABEL) {
            return BASE_URL + '/vision';
        } else if (this.typeEnum == Einstein_PredictionService.Types.SENTIMENT) {
            return BASE_URL + '/language';
        } else if (this.typeEnum == Einstein_PredictionService.Types.INTENT) {
            return BASE_URL + '/language';
        }
        return '';
    }


    /**
* 
* @return
*/
    public String getBearerToken() {
        return bearerToken;
    }
    
    public static String getAccessToken() {
        Einstein_Settings__c settings = Einstein_Settings__c.getOrgDefaults();
        ContentVersion base64Content = [SELECT Title, VersionData FROM ContentVersion where Title='einstein_platform' LIMIT 1];
        String keyContents = base64Content.VersionData.tostring();
        keyContents = keyContents.replace('-----BEGIN RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('-----END RSA PRIVATE KEY-----', '');
        keyContents = keyContents.replace('\n', '');
        
        // Get a new token
        Einstein_JWT jwt = new Einstein_JWT('RS256');
        jwt.pkcs8 = keyContents; // Comment this if you are using jwt.cert
        jwt.iss = 'developer.force.com';
        jwt.sub = settings.Einstein_EMail__c;
        jwt.aud = OAUTH2;
        jwt.exp = '3600';
        String accessToken = '';
        
        if (!Test.isRunningTest()) {
            accessToken = Einstein_JWTBearerFlow.getAccessToken(OAUTH2, jwt);
            System.debug(accessToken);
        }
        
        return accessToken;    
    }
    
}