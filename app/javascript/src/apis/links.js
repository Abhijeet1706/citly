import axios from "axios";

const list = () => axios.get("/links");

const create = payload => axios.post("/links/", payload);

const show = id => axios.get(`/links/${id}`);

const update = id => axios.put(`links/${id}`);

const linksApi = {
  list,
  create,
  show,
  update,
};

export default linksApi;
