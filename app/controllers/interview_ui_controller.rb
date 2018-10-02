class InterviewUiController < ApplicationController
	before_action :authenticate_user! 
	def interview
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
	
	def is_exist
		find = Schedule.exists?(:user_id => current_user.id, :date => params[:fulldate])
		if find
			render :json => "true", :status => 200
		else
			render :json => "false", :status => 200
		end
	end
end
