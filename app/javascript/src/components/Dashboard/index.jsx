import React, { useState, useEffect } from "react";

import Container from "components/Container";
import ListLinks from "components/Links/ListLinks";
import PageLoader from "components/PageLoader";
import linksApi from "apis/links";
// import { logger } from "common/logger";
import CreateLink from "components/Links/CreateLink";

const Dashboard = () => {
  const [links, setLinks] = useState([]);
  const [link, setLink] = useState("");
  const [loading, setLoading] = useState(false);
  const [pageLoading, setPageLoading] = useState(true);

  const handleSubmit = async event => {
    event.preventDefault();
    setLoading(true);
    try {
      await linksApi.create({ link: { original: link } });
      fetchLinks();
      setLoading(false);
    } catch (error) {
      logger.error(error);
      setLoading(false);
    }
  };

  const handlePinned = async id => {
    try {
      await linksApi.update(id);
      fetchLinks();
    } catch (error) {
      logger.error(error);
    }
  };

  const handleClicked = async slug => {
    try {
      const responds = await linksApi.show(slug);
      window.open(responds.data.link.original);
      fetchLinks();
    } catch (error) {
      logger.error(error);
    }
  };

  const fetchLinks = async () => {
    try {
      const response = await linksApi.list();
      setLinks(response.data.link);
      setLink("");
      setPageLoading(false);
    } catch (error) {
      logger.error(error);
      setPageLoading(false);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    fetchLinks();
  }, []);

  if (pageLoading) {
    return (
      <div className="w-screen h-screen">
        <PageLoader />
      </div>
    );
  }

  return (
    <Container>
      <CreateLink
        handleSubmit={handleSubmit}
        setLink={setLink}
        link={link}
        loading={loading}
      />
      <ListLinks
        data={links}
        handlePinned={handlePinned}
        handleClicked={handleClicked}
      />
    </Container>
  );
};

export default Dashboard;
