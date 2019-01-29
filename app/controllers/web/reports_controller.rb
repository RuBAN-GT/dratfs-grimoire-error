class Web::ReportsController < Web::ApplicationController
  def create
    data        = params.require(:report).permit(:url, :context)
    data[:ip]   = request.remote_ip
    data[:host] = request.host

    report = Report.new(data)

    ReportMailer.report(report).deliver_now unless report.has_errors?

    respond_to do |format|
      format.json do
        render :json => {
          :meta => {
            :status => report.has_errors? ? 'Fail' : 'Success',
            :errors => []
          }
        }
      end
    end
  end
end
