require "pry"

def find_item_by_name_in_collection(name, collection)
  index = 0
  #if name is name of item in collection, return that hash
  while index < collection.length do
    if collection[index][:item] == name
      return collection[index]
    end
    index += 1
  end
  return nil
end

def consolidate_cart(cart)
  #empty array for consolidated cart
  cons_cart = []
  #iterate through items in cart
  cart_index = 0
  while cart_index < cart.length do
    #check if new item is in cart. if it is, copy into new_cart_item
    new_cart_item = find_item_by_name_in_collection(cart[cart_index][:item], cons_cart)
    #if new_cart_item is in cons_cart, increase count
    if new_cart_item
      new_cart_item[:count] += 1
    #if item is not in consolidated cart, add to consolidated cart and add count
    else
      new_cart_item = {
        :item => cart[cart_index][:item],
        :price => cart[cart_index][:price],
        :clearance => cart[cart_index][:clearance],
        :count => 1
      }
      cons_cart << new_cart_item
    end
    cart_index += 1
  end
  return cons_cart
end

def apply_coupons(cart, coupons)
  #iterate through coupons
  coup_index = 0
  while coup_index < coupons.length do
    #check if target item of coupon is in cart
    cart_index = 0
    while cart_index < cart.length do
      #if it is in cart and hits item limit, apply coupon
      if coupons[coup_index][:item] == cart[cart_index][:item] && coupons[coup_index][:num] <= cart[cart_index][:count]
        cart[cart_index][:count] -= coupons[coup_index][:num]
        new_item = {
          :item => "#{cart[cart_index][:item]} W/COUPON",
          :price => coupons[coup_index][:cost] / coupons[coup_index][:num],
          :clearance => cart[cart_index][:clearance],
          :count => coupons[coup_index][:num]
        }
        cart << new_item
      end
        cart_index += 1
    end
    coup_index += 1
  end
  return cart
end

def apply_clearance(cart)
  #check if each item in cart has clearance, if so discount 20%
  cart_index = 0
  while cart_index < cart.length do
    if cart[cart_index][:clearance]
      new_item = (0.8 * cart[cart_index][:price]).round(2)
      cart[cart_index][:price] = new_item
      cart[cart_index][:price].round(2)
    end
    cart_index += 1
  end
  return cart
end

def checkout(cart, coupons)
  #consolidate cart, apply coupons and clearances
  cons_cart = consolidate_cart(cart)
  apply_coupons(cons_cart, coupons)
  apply_clearance(cons_cart)
  #iterate through cart, add all item prices * count and add to grand total
  total = 0
  cart_index = 0
  while cart_index < cons_cart.length do
    total += cons_cart[cart_index][:price] * cons_cart[cart_index][:count]
    cart_index += 1
  end
  #if total is more than $100, give 10% discount
  puts total
  if total > 100
    total *= 0.9
    total.round(2)
  end
  return total
end




