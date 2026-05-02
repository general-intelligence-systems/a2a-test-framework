require "a2a_test_framework/test_helper"

# NOTE: All tests commented out -- gRPC binding not supported by reference server

# require "a2a_test_framework/test_helper"

# # NOTE: All tests commented out -- gRPC binding not supported by reference server

# # describe "Streaming Event Delivery (gRPC)" do
# #   # --- Event Ordering ---
# #
# #   describe "when a task generates multiple events in sequence" do
# #     it "should deliver all events in the order they were generated" do
# #     end
# #
# #     it "should not reorder events during transmission" do
# #     end
# #
# #     it "should preserve event ordering regardless of protocol binding" do
# #     end
# #   end
# #
# #   # --- Multiple Streams Per Task ---
# #
# #   describe "when multiple clients subscribe to the same task" do
# #     it "should serve multiple concurrent streams simultaneously" do
# #     end
# #
# #     it "should broadcast events to all active streams for a task" do
# #     end
# #
# #     it "should deliver the same events in the same order to each stream" do
# #     end
# #   end
# #
# #   describe "when one client closes their stream" do
# #     it "should keep other active streams open and receiving events" do
# #     end
# #
# #     it "should not affect the task lifecycle" do
# #     end
# #   end
# #
# #   describe "when a single client opens two subscription streams for the same task" do
# #     it "should deliver events to both streams" do
# #     end
# #   end
# # end
