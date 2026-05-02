Feature: List Tasks Operation (Section 3.1.4)
  Retrieves a list of tasks with optional filtering and pagination capabilities.
  Allows clients to discover and manage multiple tasks across different contexts
  or with specific status criteria.

  # --- Authorization Scoping ---

  Scenario: Only tasks visible to the authenticated client are returned
    Given a valid A2A server
    And multiple tasks exist belonging to different clients
    When an authenticated client sends a ListTasks request
    Then the response MUST only contain tasks visible to the authenticated client
    And the response MUST NOT contain tasks belonging to other clients

  Scenario: Unauthenticated client cannot list tasks
    Given a valid A2A server
    When an unauthenticated client sends a ListTasks request
    Then the server MUST respond with an authentication error

  # --- includeArtifacts Field Behavior ---

  Scenario: Artifacts field omitted when includeArtifacts is false (default)
    Given a valid A2A server
    And tasks exist that have generated artifacts
    When a client sends a ListTasks request without setting includeArtifacts
    Then the artifacts field MUST be omitted entirely from each Task object in the response
    And the artifacts field MUST NOT be present as an empty array
    And the artifacts field MUST NOT be present as a null value

  Scenario: Artifacts field omitted when includeArtifacts is explicitly false
    Given a valid A2A server
    And tasks exist that have generated artifacts
    When a client sends a ListTasks request with includeArtifacts set to false
    Then the artifacts field MUST be omitted entirely from each Task object in the response

  Scenario: Artifacts field included when includeArtifacts is true
    Given a valid A2A server
    And tasks exist that have generated artifacts
    When a client sends a ListTasks request with includeArtifacts set to true
    Then each Task object in the response MUST include the artifacts field with its actual content

  Scenario: Artifacts field is empty array when task has no artifacts and includeArtifacts is true
    Given a valid A2A server
    And a task exists that has no artifacts
    When a client sends a ListTasks request with includeArtifacts set to true
    Then the task's artifacts field MAY be an empty array

  # --- nextPageToken Field ---

  Scenario: nextPageToken field is always present in response
    Given a valid A2A server
    And tasks exist for the authenticated client
    When a client sends a ListTasks request
    Then the response MUST contain a nextPageToken field

  Scenario: nextPageToken is empty string on final page
    Given a valid A2A server
    And the total number of tasks is less than or equal to the page size
    When a client sends a ListTasks request
    Then the nextPageToken field MUST be set to an empty string ""

  Scenario: nextPageToken is non-empty when more results exist
    Given a valid A2A server
    And more tasks exist than fit in a single page
    When a client sends a ListTasks request with a page size smaller than total tasks
    Then the nextPageToken field MUST be a non-empty string
    And the client can use it to retrieve the next page

  # --- Cursor-Based Pagination ---

  Scenario: Pagination uses cursor-based approach via pageToken
    Given a valid A2A server
    And more tasks exist than fit in a single page
    When a client sends a ListTasks request with a pageToken from a previous response
    Then the server MUST return the next set of results after the cursor position
    And the results MUST NOT overlap with previous pages

  Scenario: First page request without pageToken
    Given a valid A2A server
    And tasks exist for the authenticated client
    When a client sends a ListTasks request without a pageToken
    Then the server MUST return the first page of results

  # --- Ordering ---

  Scenario: Tasks are sorted by status timestamp in descending order
    Given a valid A2A server
    And multiple tasks exist with different last-update times
    When a client sends a ListTasks request
    Then the tasks MUST be sorted by their status timestamp in descending order
    And the most recently updated task MUST appear first

  Scenario: Ordering is consistent across paginated results
    Given a valid A2A server
    And many tasks exist with different last-update times
    When a client paginates through all results
    Then the ordering MUST be consistent across all pages
    And no task from a later page MUST have a more recent update time than tasks on earlier pages

  # --- Filtering ---

  Scenario: Filter tasks by context ID
    Given a valid A2A server
    And tasks exist across multiple context IDs
    When a client sends a ListTasks request filtering by a specific contextId
    Then the response MUST only contain tasks matching that contextId

  Scenario: Filter tasks by status
    Given a valid A2A server
    And tasks exist with various statuses
    When a client sends a ListTasks request filtering by status "completed"
    Then the response MUST only contain tasks with "completed" status
