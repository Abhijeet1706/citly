import axios from "axios";

const list = () => axios.get("/links");

const create = payload => axios.post("/links/", payload);

const show = id => axios.get(`/links/${id}`);

const update = ({ id, payload }) => axios.put(`/links/${id}`, payload);

const save = () => axios.get("/links.csv");

const linksApi = {
  list,
  create,
  show,
  update,
  save,
};

export default linksApi;
