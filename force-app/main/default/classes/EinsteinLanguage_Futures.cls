public class EinsteinLanguage_Futures {
    
	@Future(callout=true)
    public static void getEinsteinLanguagePrediction(Id caseId) {
        Case c = [SELECT Id, Description FROM Case WHERE Id=:caseId];
        // EinsteinLanguage_PredictionService service = new EinsteinLanguage_PredictionService();
        // EinsteinLanguage_PredictionResult resultIntent = service.predictIntent('GlobalIntentModel', c.Description);
        // EinsteinLanguage_PredictionResult resultSentiment = service.predictSentiment('CommunitySentiment', c.Description);
        // c.Einstein_Language_Sentiment__c = resultSentiment.probabilities.get(0).label;
        // c.Einstein_Language_Intent__c = resultIntent.probabilities.get(0).label;
        // update c;

		// // Call method to publish events
		// List<Database.SaveResult> results = EventBus.publish(inkEvents);
    }

}