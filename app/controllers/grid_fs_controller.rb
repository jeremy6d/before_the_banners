class GridFsController < ActionController::Metal
  def serve
    gridfs_file = Mongoid::GridFs[env["PATH_INFO"].gsub("/media/", "")]

    if gridfs_file
      self.status = :ok
      self.content_type = gridfs_file.content_type
      self.response_body = gridfs_file.chunks
    else
      self.status = :not_found
      self.content_type = "text/plain"
      self.response_body = "Not found"
    end
  end
end