require 'elasticsearch/model'

class Article < ActiveRecord::Base
	ac_field :title
	include Elasticsearch::Model
	include Elasticsearch::Model::Callbacks

	def self.search(query)
		__elasticsearch__.search(
			{
				query: {
					multi_match: {
						query: query,
						fields: ['title^10', 'text']
					}
				},
				highlight: {
	        pre_tags: ['<em>'],
	        post_tags: ['</em>'],
	        fields: {
	          title: {},
	          text: {}
	        }
				}
			}		
		)
	end
end
Article.import force: true# for auto sync model with elastic search