class DatosReportablesController < ApplicationController
 
  def show
       
    begin
      @datoReportable =  DatoReportable.find( params[:id]);
    rescue ActiveRecord::RecordNotFound
     
    end
    
    render :json =>  @datoReportable ;

  end



end
