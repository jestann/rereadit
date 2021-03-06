require 'rails_helper'
include SessionsHelper

RSpec.describe VotesController, type: :controller do
    let(:user) { create(:user) }
    let(:topic) { create(:topic) }
    let(:other_user) { create(:user) }
    let(:a_post) { create(:post) }
    let(:vote) { create(:vote) }
    
    context "guest" do
        describe "POST up_vote" do
            it "redirects the user to sign in" do
                post :up_vote, post_id: a_post.id
                expect(response).to redirect_to new_session_path
            end
        end
        
        describe "POST down_vote" do
            it "redirects the user to sign in" do
                post :down_vote, post_id: a_post.id
                expect(response).to redirect_to new_session_path
            end
        end
    end
    
    context "signed in user" do
        before do
            create_session(user)
            request.env["HTTP_REFERER"] = topic_post_path(topic, a_post)
        end
        
        describe "POST up_vote" do
            it "increases number of votes by one if first vote" do
                votes = a_post.votes.count
                post :up_vote, post_id: a_post.id
                expect(a_post.votes.count).to eq(votes+1)
            end
            
            it "doesn't increase votes if a second vote" do
                post :up_vote, post_id: a_post.id
                votes = a_post.votes.count
                post :up_vote, post_id: a_post.id
                expect(a_post.votes.count).to eq votes
            end
            
            it "increases points by one" do
                points = a_post.points
                post :up_vote, post_id: a_post.id
                expect(a_post.points).to eq(points+1)
            end
            
            it ":back redirects to posts show page" do
                request.env["HTTP_REFERER"] = topic_post_path(topic, a_post)
                post :up_vote, post_id: a_post.id
                expect(response).to redirect_to [topic, a_post]
            end
            
            it ":back redirects to posts topic show" do
                request.env["HTTP_REFERER"] = topic_path(topic)
                post :up_vote, post_id: a_post.id
                expect(response).to redirect_to topic
            end
        end
        
        describe "POST down_vote" do
            it "increases number of votes by one if first vote" do
                votes = a_post.votes.count
                post :down_vote, post_id: a_post.id
                expect(a_post.votes.count).to eq(votes+1)
            end
            
            it "doesn't increase votes if a second vote" do
                post :down_vote, post_id: a_post.id
                votes = a_post.votes.count
                post :down_vote, post_id: a_post.id
                expect(a_post.votes.count).to eq votes
            end
            
            it "decreases points by one" do
                points = a_post.points
                post :down_vote, post_id: a_post.id
                expect(a_post.points).to eq(points-1)
            end
            
            it ":back redirects to posts show page" do
                request.env["HTTP_REFERER"] = topic_post_path(topic, a_post)
                post :up_vote, post_id: a_post.id
                expect(response).to redirect_to [topic, a_post]
            end
            
            it ":back redirects to posts topic show" do
                request.env["HTTP_REFERER"] = topic_path(topic)
                post :up_vote, post_id: a_post.id
                expect(response).to redirect_to topic
            end
        end
                
    end

end
