module RequestHelpers
  def parse_req_as_json
    input = req.body.read
    JSON.parse(input)
  end
end
