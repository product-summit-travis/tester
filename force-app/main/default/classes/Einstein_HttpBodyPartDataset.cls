public class Einstein_HttpBodyPartDataset extends Einstein_HttpBodyPart {

    private String name;
    private String labels;
    
    public Einstein_HttpBodyPartDataset(String name, String[] labels)  {
        if (name==null || name.equals('')) {
            throw new Einstein_StringIsEmptyException('name');
        }
        if (name.length()>180) {
            throw new Einstein_StringTooLongException('name', 180, name.length());
        }
        if (labels==null) {
            throw new Einstein_NullPointerException('Labels cannot be null');
        }
        if (labels.size()==0) {
            throw new Einstein_NoValuesException('labels');
        }
        if (labels.size()>1000) {
            throw new Einstein_TooManyValuesException('labels', 1000, labels.size());
        }
        this.name = name;
        this.labels = String.join(labels, ',');
    }
    
    public Blob build() {
        String body = '';
        body += WriteBoundary();
        body += WriteBodyParameter('name', name);
        body += WriteBoundary();
        body += WriteBodyParameter('labels', labels);
        body += WriteBoundary(EndingType.CrLf);
        Blob bodyBlob = EncodingUtil.base64Decode(body);
        return bodyBlob;
    }
    
    public String getName() {
        return name;
    }

    public void setName(String name)  {
        if (name==null || name.equals('')) {
            throw new Einstein_StringIsEmptyException('name');
        }
        if (name.length()>180) {
            throw new Einstein_StringTooLongException('name', 180, name.length());
        }
        this.name = name;
    }
    
    public String getLabels() {
        return labels;
    }

    public void setLabels(String[] labels)  {
        if (labels==null) {
            throw new Einstein_NullPointerException('Labels cannot be null');
        }
        if (labels.size()==0) {
            throw new Einstein_NoValuesException('labels');
        }
        if (labels.size()>1000) {
            throw new Einstein_TooManyValuesException('labels', 1000, labels.size());
        }
        this.labels = String.join(labels, ',');
    }
    
}