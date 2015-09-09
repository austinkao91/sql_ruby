require './QuestionsDatabase.rb'
require './users'
require './replies.rb'
require './questions.rb'
require './question_follows'
require './questionlike'

# a = Questions.find_by_id(1)
# p a.followers
#
# b = Users.find_by_id(1)
# p b.followed_questions

#b = QuestionLike.most_liked_questions(2)
# a =  Users.find_by_id(2)
# p a.average_karma

#a = Questions.find_by_id(1)
#p a.num_likes

a = Questions.find_by_id(4)
a.title = 'Success!'
a.save
