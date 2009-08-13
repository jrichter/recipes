module InPlaceEditable

  # Adds proxy attributes to the column specified.
  # Proxy columns start with 'in_place_' followed by the column name.
  # Adds validation and adds a dash when the column is blank.
  #
  # Example:
  #
  #   # In your model:
  #   class User < ActiveRecord::Base
  #     in_place_editable_columns :name, :email
  #   end
  #   
  #   # In your controller:
  #   class UsersController < ApplicationController
  #     in_place_edit_for :user, :name
  #     in_place_edit_for :user, :email
  #   end
  #
  #   # In your view:
  #   <%= in_place_editor_field :user, :in_place_name %>
  #   <%= in_place_editor_field :user, :in_place_email %>
  def in_place_editable_columns(*columns)
    columns.each do |a|
      define_method "in_place_#{a}" do
        v = read_attribute(a)
        v = 'click to enter information' if v.blank?
        v
      end
      define_method "in_place_#{a}=" do |val|
        old = read_attribute(a)
        write_attribute(a, val)
        write_attribute(a, old) unless valid?
      end
    end
  end

end
