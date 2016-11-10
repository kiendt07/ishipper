class Shop::InvoicesController < Shop::ShopBaseController
  load_and_authorize_resource

  def show
  end

  def new
  end

  def index
    @supports = Supports::Invoice.new current_user
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

  private
  def invoice_params
    params.require(:invoice).permit Invoice::ATTRIBUTES_PARAMS
  end
end