require "test_helper"
require File.expand_path(Rails.root.join('test','fakes','blog_post.rb'))
require File.expand_path(Rails.root.join('test','fakes','comment.rb'))

class AssociationExtrasTest < ActiveSupport::TestCase

  attr_reader :blog_post

  def setup
    @blog_post = BlogPost.create(title: "A blog post")
    blog_post.build_comments({"1" => {text: "Comment 1"}, "2" => {text: "Comment 2"}})
  end

  test "a blog post should be able to build some comments" do
    assert_equal 2, blog_post.comments.length
    assert blog_post.comments.all? {|o| o.new_record?}
  end

  test "a blog post should be able to save some comments" do
    blog_post.save_comments
    assert_equal 2, blog_post.comments.length
    refute blog_post.comments.all? {|o| o.new_record?}
  end

  test "a blog post should be able to update some comments" do
    blog_post.save_comments
    blog_post.update_comments({"3" => {text: "Comment 3"}, "4" => {text: "Comment 4"}, "5" => {text: "Comment 5"}})
    blog_post.save_comments
    assert_equal 3, blog_post.comments.length
    assert_nil blog_post.comments.find_by(text: "Comment 1")
    assert_instance_of Comment, blog_post.comments.find_by(text: "Comment 3")
  end


end