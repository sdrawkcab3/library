class ScanController < ApplicationController
  before_action only: [:new] do
    book_from_scan(params[:isbn])
  end

  require 'json'
  require 'net/http'
  require 'uri'

  def new
  end #end new

  def create
    #@book = Book.new(book_params)

    @book = current_user.books.build(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to book_url(@book), notice: "Book was successfully created." }
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end


def book_from_scan(isbn)

  def join_field(field)
    field.map do |a|
      "#{a['name']}"
    end.join
  end
  isbn_link = "https://openlibrary.org/api/books?bibkeys=ISBN:"+isbn+"&jscmd=data&format=json"
  uri = URI.parse(isbn_link)
  response = Net::HTTP.get_response(uri)
  parsed_json = JSON.parse(response.body)
  @info = parsed_json["ISBN:"+isbn]


  authors = join_field(@info['authors'])
  publishers = join_field(@info['publishers'])

  @book = current_user.books.build(
    title: @info['title'],
    authors: authors,
    publisher: publishers,
    edition: @info['publish_date'],
    pages: @info['number_of_pages'],
    isbn: isbn,
    cover_link: @info['cover']['medium'],
    user_id: current_user)

end

end #end controller
