class TooltipSerializer < ApplicationSerializer
  attributes :id,
    :slug,
    :body,
    :created_at,
    :updated_at,
    :replacement
end
