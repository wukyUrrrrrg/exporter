# -*- coding: utf-8 -*-
class Admin::ExporterController < Admin::BaseController

  def export_contacts
    @search = Order.metasearch(params[:search])
    # @search = @search.email_does_not_equal('').email_does_not_equal(nil)
    @orders = @search.all

    @outfile = "polzovateli_" + Time.now.strftime("%m-%d-%Y") + ".csv"
    
    csv_data = FasterCSV.generate do |csv|
      csv << [
              "last_name",
              "name",
              "Email",
              "Телефон",
              "city",
              "zipcode"
             ]
      @orders.each do |order|
        csv << [
                (order.ship_address and not order.ship_address.lastname.blank?) ? order.ship_address.lastname.mb_chars.capitalize.to_s : nil,
                (order.ship_address and not order.ship_address.lastname.blank?) ? order.ship_address.firstname.mb_chars.capitalize.to_s : nil,
                order.email,
                (order.ship_address and not order.ship_address.phone.blank?) ? format_phone_number(order.ship_address.phone) : nil,
                order.ship_address ? order.ship_address.city : nil,
                order.ship_address ? order.ship_address.zipcode : nil
               ]
      end
    end
    
    send_data csv_data,
    :type => 'text/csv; charset=utf-8; header=present',
    :disposition => "attachment; filename=#{@outfile}"
  end

  private
  # bring gathered phone number to the russian standard (+7 xxx xxxxxxx)
  def format_phone_number phone
    phone.gsub!(/\D/, "")
    phone.insert( 0, '7') if phone.length == 10
    if phone.length == 11
      phone[0] = '7' if phone[0..0] == '8'
      if phone[0..1] == '79' 
        phone.insert(0,'+')
        phone
      end
    end
  end

end
