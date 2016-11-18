class Shop::InvoicesController < Shop::ShopBaseController
  load_and_authorize_resource

  def index
    @invoices = current_user.invoices.
      send(params[:invoice][:status]) if params[:invoice] && params[:invoice][:status]
  end

  def show
  end

  def new
  end

  def create
    if params[:invoice_form_id] == "form_map_marker"
      @invoice = Invoice.new invoice_params
      error = CheckInvoiceMapMarker.new(@invoice).perform
      if error.present?
        flash[:danger] = error
        redirect_to new_shop_invoice_path
      end
    else
      if @invoice.save
        InvoiceHistoryCreator.new(@invoice, current_user.id).create_history invoice_params
        flash[:success] = t "invoices.create.success"
        redirect_to root_path
      end
    end
  end

  def update
    if InvoiceStatus.new(@invoice, @user_invoice, params[:status] || invoice_params,
      current_user).shop_update?
      flash[:success] = t "invoices.messages.update_success"
    else
      flash[:danger] = t "invoices.messages.cant_update"
    end
    redirect_to :back
  end

  private
  def invoice_params
    params.require(:invoice).permit Invoice::ATTRIBUTES_PARAMS
  end
end
