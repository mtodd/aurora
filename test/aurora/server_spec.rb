describe "Aurora::Server" do
  
  before do
    @serv = Specr.new :port => 6211
  end
  
  it "should authenticate users with proper credentials" do
    response = JSON.parse(Rack::MockRequest.new(@serv).post("/user/auth/test", :input => '&password=pass&').body)
    response['status'].should == 200
  end
  
  it "should provide a token for authenticated users with proper credentials" do
    response = JSON.parse(Rack::MockRequest.new(@serv).post("/user/auth/test", :input => '&password=pass&').body)
    response['status'].should == 200
    response['body'].should == Digest::MD5.hexdigest(Time.now.to_s)
  end
  
  it "should return unauthorized error if improper credentials are attempting authentication" do
    response = JSON.parse(Rack::MockRequest.new(@serv).post("/user/auth/test", :input => '&password=fail&').body)
    response['status'].should == 401
    response['body'].should == 'Unauthorized'
  end
  
end
