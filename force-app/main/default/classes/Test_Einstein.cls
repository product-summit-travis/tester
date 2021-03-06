@isTest
public with sharing class Test_Einstein {
    
    
    static testMethod void getDataset() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_Dataset dataset = service.getDataset(57);
        
        // Test 1: Valid Dataset returned
        System.assertEquals('Beach and Mountain', dataset.name);
        System.assertEquals(DateTime.newInstanceGmT(2016,9,15,16,51,41), dataset.updatedAt);
    }
    
    static testMethod void getDatasets() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        List<Einstein_Dataset> datasets = service.getDatasets();
        
        System.assertEquals(2, datasets.size());
        
        for (Einstein_Dataset dataset : datasets) {
            if (dataset.id == 57) {
                System.assertEquals('Beach and Mountain', dataset.name);
            }
        }
    }
    
    static testMethod void deleteDataset() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Boolean success = service.deleteDataset(108);
        
        System.assertEquals(true, success);
        
        Einstein_Dataset dataset = new Einstein_Dataset();
        dataset.id = 108;
        
        success = service.deleteDataset(dataset);
        
        System.assertEquals(true, success);
        
    }
    
     
    static testMethod void createExample() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_Example example = service.createExample(57, '77880132.jpg', 614, Blob.valueOf('data'));
        
        System.assertEquals(43887, example.id);
        System.assertEquals('77880132.jpg', example.name);
        System.assertEquals('https://jBke4mtMuOjrCK3A04Q79O5TBySI2BC3zqi7...', example.location);
        System.assertEquals(DateTime.newInstanceGmt(2016,9,15,23,18,13), example.createdAt);
        
    }
    
    static testMethod void createExamplesFromUrl() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_Dataset dataset = service.createExamplesFromUrl(1000022, 'http://my.image.com/test.png');
        
        System.assertEquals('mountainvsbeach', dataset.name);
        System.assertEquals(DateTime.newInstanceGmt(2017,2,17,0,22,10), dataset.createdAt);
        System.assertEquals(DateTime.newInstanceGmt(2017,2,17,0,22,12), dataset.updatedAt);
        
        try {
            dataset = service.createExamplesFromUrl(1000022, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringIsEmptyException'));
        }
        
    }
    
    static testMethod void getExamples() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        List<Einstein_Example> examples = service.getExamples(57);
        
        System.assertEquals(4, examples.size());
        
        Einstein_Dataset dataset = new Einstein_Dataset();
        dataset.id = 57;
        
        examples = service.getExamples(dataset);
        
        System.assertEquals(4, examples.size());
        
    }
    
    static testMethod void trainDataset() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_Model model = service.trainDataset(57, 'Beach and Mountain Model', 0, 0, '');
        
        System.assertEquals(DateTime.newInstanceGmt(2016,9,16,18,3,21), model.createdAt);
        System.assertEquals(DateTime.newInstanceGmt(2016,9,16,18,3,21), model.updatedAt);
        System.assertEquals(57, model.datasetId);
        System.assertEquals(0, model.datasetVersionId);
        System.assertEquals('Beach and Mountain Model', model.name);
        System.assertEquals('QUEUED', model.status);
        System.assertEquals(0, model.progress);
        System.assertEquals(0.001, model.learningRate);
        System.assertEquals(3, model.epochs);
        System.assertEquals(1, model.queuePosition);
        System.assertEquals('7JXCXTRXTMNLJCEF2DR5CJ46QU', model.modelId);
        System.assertEquals(null, model.trainParams);
        System.assertEquals(null, model.trainStats);
        System.assertEquals('image', model.modelType);
        System.assertEquals(null, model.failureMsg);
        
        Einstein_Dataset dataset = new Einstein_Dataset();
        dataset.id = 57;
        
        model = service.trainDataset(dataset, 'Beach and Mountain Model', 0, 0, '');
        System.assertEquals('Beach and Mountain Model', model.name);
        
        model = service.trainDataset(dataset, 'Beach and Mountain Model', 6, 0, '');
        System.assertEquals('Beach and Mountain Model', model.name);
        
        
        try {
            model = service.trainDataset(0, 'Beach and Mountain Model', 0, 0, '');
        } catch (Exception e) {
            System.debug('Error is: ' + e.getTypeName());
            System.assert(e.getTypeName().equals('Einstein_NoValuesException'));
        }
        
        try {
            model = service.trainDataset(57, '', 0, 0, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringIsEmptyException'));
        }
        
        try {
            String nameTooLong = 'AbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefg';
            model = service.trainDataset(57, nameTooLong, 0, 0, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringTooLongException'));
        }
        
        try {
            model = service.trainDataset(57, 'Beach and Mountain Model', 101, 0, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooBigException'));
        }
        
        try {
            model = service.trainDataset(57, 'Beach and Mountain Model', 101, 0, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooBigException'));
        }
        
        try {
            model = service.trainDataset(57, 'Beach and Mountain Model', 0, 0.00001, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooSmallException'));
        }
        
        try {
            model = service.trainDataset(57, 'Beach and Mountain Model', 0, 0.1, '');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooBigException'));
        }
        
    }
    
    static testMethod void getModel() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_Model model = service.getModel('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        
        // TODO System.assertEquals(DateTime.newInstance(), model.createdAt);
        // TODO System.assertEquals(DateTime.newInstance(), model.updatedAt);
        System.assertEquals(57, model.datasetId);
        System.assertEquals(0, model.datasetVersionId);
        System.assertEquals('Beach and Mountain Model', model.name);
        System.assertEquals('SUCCEEDED', model.status);
        System.assertEquals(1, model.progress);
        System.assertEquals(0.001, model.learningRate);
        System.assertEquals(3, model.epochs);
        System.assertEquals('7JXCXTRXTMNLJCEF2DR5CJ46QU', model.modelId);
        // TODO System.assertEquals('{"trainSplitRatio": 0.7}', model.trainParams);
        System.assertEquals(null, model.trainStats);
        System.assertEquals('image', model.modelType);
        
        Einstein_Dataset dataset = new Einstein_Dataset();
        dataset.id = 57;
        
        model = service.getModel('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        System.assertEquals('Beach and Mountain Model', model.name);
        
    }
    
    static testMethod void getModelLearningCurve() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_ModelLearningCurve[] learningCurves = service.getModelLearningCurve('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        
        System.assertEquals(1, learningCurves.get(0).epoch);
        //System.assertEquals('Mountains', learningCurves.get(0).metricsData.labels.get(0));
        System.assertEquals('521811667.jpg-Mountains', learningCurves.get(0).epochResults.get(3).exampleName);
        System.assertEquals('Mountains', learningCurves.get(0).epochResults.get(3).expectedLabel);
        System.assertEquals('Beaches', learningCurves.get(0).epochResults.get(3).predictedLabel);
        
    }
    
    static testMethod void getModelMetrics() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_ModelMetrics metrics = service.getModelMetrics('7JXCXTRXTMNLJCEF2DR5CJ46QU');
        
        System.assertEquals(0.9286, metrics.testAccuracy);
        System.assertEquals(0.9941, metrics.trainingAccuracy);
        System.assertEquals(0.021, metrics.trainingLoss);
        
        System.assertEquals(0.9090909090909092, metrics.f1.get(0));
        System.assertEquals(8, metrics.confusionMatrix.get(1).get(1));
        
    }
    
    static testMethod void getModels() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        List<Einstein_Model> models = service.getModels(57);
        
        System.assertEquals(2, models.size());
        Einstein_Model model = models.get(0);
        System.assertEquals('To train a dataset and create a model, the dataset must contain at least 100 examples per label for test set', model.failureMsg);
        
        Einstein_Dataset dataset = new Einstein_Dataset();
        dataset.id = 57;
        models = service.getModels(dataset);
        
        System.assertEquals(2, models.size());
        
    }
    
    static testMethod void predictBase64() {
        
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_PredictionResult result = service.predictImageBase64('YCQ4ZACEPJFGXZNRA6ERF3GL5E', 'aaabbbccc', 0, '');
        
        System.assertEquals(2, result.probabilities.size());
        System.assertEquals('beach', result.probabilities.get(0).label);
        System.assertEquals(0.039788953959941864, result.probabilities.get(1).probability);
        
        Einstein_Model model = new Einstein_Model();
        model.modelId = 'YCQ4ZACEPJFGXZNRA6ERF3GL5E'; 
        
        result = service.predictImageBase64(model, 'aaabbbccc', 0, '');
        System.assertEquals(2, result.probabilities.size());
        
    }
    
    static testMethod void apiUsage() {
    
        Einstein_PredictionService service = new Einstein_PredictionService('123', Einstein_PredictionService.Types.IMAGE);
        
        Test.setMock(HttpCalloutMock.class, new Test_Einstein_HttpMockResponses());
        
        Einstein_ApiUsage[] apiUsages = service.getApiUsage();
        
        System.assertEquals(1, apiUsages.size());
        
        Einstein_ApiUsage apiUsage = apiUsages.get(0);
        
        System.assertEquals('489', apiUsage.id);
        System.assertEquals('108', apiUsage.organizationId);
        System.assertEquals('kJCHtYDCSf', apiUsage.licenseId);
        System.assertEquals(997, apiUsage.predictionsRemaining);
        System.assertEquals(3, apiUsage.predictionsUsed);
        System.assertEquals(1000, apiUsage.predictionsMax);
        System.assertEquals('2017-03-01T00:00:00.000Z', apiUsage.startsAt);
        System.assertEquals('2017-04-01T00:00:00.000Z', apiUsage.endsAt);
        
        Einstein_PlanData planData = apiUsage.planData.get(0);
        System.assertEquals('FREE', planData.plan);
        System.assertEquals('HEROKU', planData.source);
        System.assertEquals(1, planData.amount);
    
    }
    
    
    static testMethod void testOtherMethods() {
        
        System.assertEquals('1ff13444ed8140c7a32fc4e6451aa76d', Einstein_HttpBodyPart.getBoundary());
        
        String[] labels = new String[]{'a', 'b'};
            Einstein_HttpBodyPartDataset bodyPartDataset = new Einstein_HttpBodyPartDataset('Test1', labels);
        
        System.assertEquals('Test1', bodyPartDataset.getName());
        
        bodyPartDataset.setName('Test2');
        System.assertEquals('Test2', bodyPartDataset.getName());
        
        System.assertEquals('a,b', bodyPartDataset.getLabels());
        
        try {
            bodyPartDataset.setName('');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringIsEmptyException'));
        }
        
        try {
            String nameTooLong = 'AbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefg';
            bodyPartDataset.setName(nameTooLong);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringTooLongException'));
        }
        
        try {
            bodyPartDataset.setLabels(null);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NullPointerException'));
        }
        
        try {
            String[] labelsEmpty = new String[]{};
                bodyPartDataset.setLabels(labelsEmpty);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NoValuesException'));
        }
        
        try {
            String[] labelsTooBig = new String[]{};
                for (Integer i=0;i<1002;i++) {
                    labelsTooBig.add('Label' + i);
                }
            bodyPartDataset.setLabels(labelsTooBig);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_TooManyValuesException'));
        }
        
        Einstein_HttpBodyPartDatasetUrl bodyPartDatasetUrl = new Einstein_HttpBodyPartDatasetUrl('http://my.test1.com', 'image');
        
        bodyPartDatasetUrl.setUrl('http://my.test2.com');
        System.assertEquals('http://my.test2.com', bodyPartDatasetUrl.getUrl());
        
        try {
            bodyPartDatasetUrl.setUrl('');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringIsEmptyException'));
        }
        
        Einstein_HttpBodyPartPrediction bodyPartPrediction = new Einstein_HttpBodyPartPrediction('modelId1', 'testData1', 0, '', Einstein_HttpBodyPartPrediction.TYPES.BASE64);
        
        bodyPartPrediction.setModelId('modelId2');
        System.assertEquals('modelId2', bodyPartPrediction.getModelId());
        
        bodyPartPrediction.setData('data2');
        System.assertEquals('data2', bodyPartPrediction.getData());        
        
        bodyPartPrediction.setSampleId('sampleId2');
        System.assertEquals('sampleId2', bodyPartPrediction.getSampleId());
        
        bodyPartPrediction.setType(Einstein_HttpBodyPartPrediction.Types.URL);
        System.assertEquals(Einstein_HttpBodyPartPrediction.Types.URL, bodyPartPrediction.getType());
        
        Einstein_HttpBodyPartTraining bodyPartTraining = new Einstein_HttpBodyPartTraining(1, 'Test1', 0, 0, '');
        
        bodyPartTraining.setDatasetId(2);
        System.assertEquals(2, bodyPartTraining.getDatasetId());
        
        try {
            bodyPartTraining.setDatasetId(0);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NoValuesException'));
        }  
        
        bodyPartTraining.setName('Test2');
        System.assertEquals('Test2', bodyPartTraining.getName());
        
        try {
            bodyPartTraining.setName('');
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringIsEmptyException'));
        }     
        
        try {
            String nameTooLong = 'AbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefgAbcdefg';
            bodyPartTraining.setName(nameTooLong);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_StringTooLongException'));
        }
        
        bodyPartTraining.setEpochs(5);
        System.assertEquals(5, bodyPartTraining.getEpochs());
        
        try {
            bodyPartTraining.setEpochs(101);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooBigException'));
        }
        
        bodyPartTraining.setLearningRate(0.001);
        System.assertEquals(0.001, bodyPartTraining.getLearningRate());
        
        try {
            bodyPartTraining.setLearningRate(0.1);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooBigException'));
        }
        
        try {
            bodyPartTraining.setLearningRate(0.00001);
        } catch (Exception e) {
            System.assert(e.getTypeName().equals('Einstein_NumberTooSmallException'));
        } 
        
    }
    
    static testMethod void testJWT() {
        
        Einstein_JWT jwt = new Einstein_JWT('a');
        jwt.iss = 'b';
        jwt.aud = 'c';
        jwt.exp = 'd';
        jwt.iat = 'e';
        jwt.validFor = 1;
        jwt.cert = 'f';
        jwt.pkcs8 = 'g';
        jwt.privateKey = 'h';
        
        System.assertEquals('a', jwt.alg);
        System.assertEquals('b', jwt.iss);
        System.assertEquals('c', jwt.aud);
        System.assertEquals('d', jwt.exp);
        System.assertEquals('e', jwt.iat);
        System.assertEquals('f', jwt.cert);
        System.assertEquals('g', jwt.pkcs8);
        System.assertEquals('h', jwt.privateKey);
        System.assertEquals(1, jwt.validFor);
        
        
    }
    
}