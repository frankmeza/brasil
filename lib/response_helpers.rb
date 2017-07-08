module ResponseHelpers
  def set_response_as_json
    res.headers['Content-Type'] = 'application/json'
  end

  def remove_content_type_headers
    res.headers.delete('Content-Type')
  end

  def set_response_status(code)
    res.status = code
  end

  def write_res_as_json(object)
    res.write(object.to_json)
  end
end
