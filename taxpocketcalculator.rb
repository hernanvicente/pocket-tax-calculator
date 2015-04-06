require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'

class Tax
  attr_reader :sales, :tax1, :tax2, :total_gross
  attr_writer :sales

  TAX_PERCENT_1 = 0.18
  TAX_PERCENT_2 = 0.02
  DETRACT_PERCENT = 0.09

  def initialize(sales)
    @sales        = sales.to_i
    @tax1         = (@sales * TAX_PERCENT_1).round(2)
    @tax2         = @sales * TAX_PERCENT_2
    @total_gross  = @sales + @tax1
  end

  def to_detract
    ((@sales + @tax1) * DETRACT_PERCENT).round(2)
  end

  def paid_by_client
    (@sales + @tax1) - to_detract
  end

  def list
    [@tax1 - to_detract, @tax2]
  end

  def to_pay
    list.inject(0) do |sum, t|
      sum + t
    end
  end

end

get '/' do
  if params[:n]
    @taxes = Tax.new(params[:n])
    slim :index
  else
    slim :form
  end
end
