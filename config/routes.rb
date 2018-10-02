Rails.application.routes.draw do
  devise_for :users
	get '/main' => 'main_ui#main_ui'
	get '/interview' => 'interview_ui#interview'
	get '/schedule' => 'interview_ui#schedule'
	get '/applicant' => 'interview_ui#applicant'
	get '/questions' => 'interview_ui#questions'
	get '/information' => 'interview_ui#information'
	get '/link' => 'interview_ui#link'
	get '/style' => 'interview_ui#style'
	get '/mypage' => 'interview_ui#mypage'
	get '/questions/read' => 'interview_ui#questions_read'
	get '/applicant/read' => 'interview_ui#applicant_read'
	get '/schedule/read' => 'interview_ui#schedule_read'
	get '/schedule/check' => 'interview_ui#is_exist'
	post '/applicant/create' => 'interview_ui#applicant_create'
	post '/schedule/create' => 'interview_ui#schedule_create'
	patch '/schedule/patch' => 'interview_ui#schedule_patch'
	authenticated :user do
		root 'interview_ui#interview', as: :authenticated_root
	end
	root 'main_ui#main_ui'
end
