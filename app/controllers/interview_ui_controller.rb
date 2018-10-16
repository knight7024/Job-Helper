require 'open-uri'
require 'json'
require "net/https"
require "uri"
require 'faraday'

class InterviewUiController < ApplicationController
	before_action :authenticate_user!
	def interview
		pageId = params[:page]
		videoId = params[:'video-analytics']
		if pageId == '1'
			render "interview.html.erb"
		end
		if videoId == '1'
			render "video_1.html.erb"
		elsif videoId == '2'
			render "video_2.html.erb"
		end
	end
	
	def schedule
	end
	
	def applicant
		@find = IsPassed.where(:user_id => current_user.id)
	end
	
	def questions
		@list = QuestionsList.order("RANDOM()").first(5)
	end
	
	def information
		pageId = params[:page]
		if pageId == '1'
			render "information.html.erb"
		elsif pageId == '2'
			render "information_2.html.erb"
		end
	end
	
	def link
	end
	
	def style
	end
	
	def mypage
	end
	
	def searchLocation
		cID = ENV["Naver_Search_Client_ID"]
    cSecret = ENV["Naver_Search_Client_Secret"]
		sWord = params[:query].to_s
		res = Faraday.get do |req|
			req.url "https://openapi.naver.com/v1/search/local.json?query=#{sWord}&display=10&start=1"
			req.headers = { 'Host' => 'openapi.naver.com',
											'User-Agent' => 'curl/7.49.1',
											'Accept' => '*/*',
											'X-Naver-Client-Id' => cID,
											'X-Naver-Client-Secret' => cSecret }
    end
		resBody = JSON.parse(res.body)
		render :json => resBody['items']
	end
	# def renderText
	# 	modalId = params[:id]
	# 	data = File.read("#{Rails.root}/app/views/interview_ui/info2_modal#{modalId}.txt")
	# 	render :text => data
	# end
	
	def questions_read
		list = QuestionsList.order("RANDOM()").first(5)
		render :json => list, :status => 200
	end
	
	def applicant_create
		if params[:applicantId] == ''
			write = IsPassed.new
		else
			write = IsPassed.find(params[:applicantId]);
		end
		write.user_id = current_user.id
		write.company_name = params[:company_name]
		write.work_name = params[:work_name]
		write.deadline = params[:deadline]
		write.site_name = params[:site_name]
		write.deadline = params[:deadline]
		write.passed = params[:passed]
		write.startdate = params[:startdate]
		write.company_site = params[:company_site]
		write.save
		redirect_to :back
	end
	
	def applicant_read
		read = IsPassed.where(:id => params[:id])
		render :json => read, :status => 200
	end
	
	def applicant_destroy
		read = IsPassed.find_by(:id => params[:id])
		if read.user_id == current_user.id
			if read.destroy!
				render :json => "true", :status => 200
			else
				render :json => "false", :status => 200
			end
		else
			render :json => "false", :status => 200
		end
	end
	
	def schedule_create
		write = Schedule.new
		write.user_id = current_user.id
		write.date = params[:picked]
		write.title = params[:title]
		write.content = params[:content]
		write.save
		redirect_to :back
	end
	
	def schedule_patch
		write = Schedule.find_by(:user_id => current_user.id, :date => params[:picked])
		write.update({:title => params[:title], :content => params[:content]})
		redirect_to :back
	end
	
	def schedule_read
		find = Schedule.where(:user_id => current_user.id, :date => params[:fulldate])
		render :json => find, :status => 200
	end
	
	def schedule_is_exist
		find = Schedule.exists?(:user_id => current_user.id, :date => params[:fulldate])
		if find
			render :json => "true", :status => 200
		else
			render :json => "false", :status => 200
		end
	end
end
