class Api::V2::AwsSignaturesController < Api::V1::BaseController
  skip_before_filter :authenticate_application!

  def create
    signer = AwsSigner.new(signature_parameters.file_name, signature_parameters.mime_type)
    render json: {
      signed_url: signer.signed_url,
      public_url: signer.url
    }, status: 201
  end

  protected

  def signature_parameters
    params.require(:file_name)
    params.require(:mime_type)
    Hashie::Mash.new(params)
  end
end