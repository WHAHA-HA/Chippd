require 'spec_helper'

describe NewsletterController do
  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'thanks'" do
    it "returns http success" do
      get 'thanks'
      response.should be_success
    end
  end
end