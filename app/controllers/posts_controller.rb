class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
    render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "posts/post", locals: { post: @post })
  end

  def create
  @post = Post.new(post_params)

  if @post.save
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: [
          # use flash if needed
          # turbo_stream.replace("flash_messages", partial: "shared/flash_messages", locals: { flash_message: flash[:notice] }),
          turbo_stream.prepend("posts", partial: "posts/post", locals: { post: @post }),
          turbo_stream.replace("post_form", partial: "posts/form", locals: { post: Post.new })
        ]
      end
      format.html { redirect_to posts_url, notice: "Post created." }
    end
  else
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("post_form", partial: "posts/form", locals: { post: @post })
      end
      format.html { render :new, status: :unprocessable_entity }
    end
  end
end


  def edit
    @post = Post.find(params[:id])
      render turbo_stream: turbo_stream.replace("post_#{@post.id}", partial: "posts/edit_form", locals: { post: @post })
  end

  def update
    @post = Post.find(params[:id])

    if @post.update(post_params)
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form_#{@post.id}", partial: "posts/post", locals: { post: @post })
        end
        format.html { redirect_to posts_url, notice: "Post updated." }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace("post_form_#{@post.id}", partial: "posts/edit_form", locals: { post: @post })
        end
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    if @post.destroyed?
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove("post_#{@post.id}") }
      format.html { redirect_to posts_url, notice: "Post was successfully deleted." }
    end
    else
      render "form", status: :unprocessable_entity
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
